import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/posts/application/posts_controller.dart';
import 'package:lumina/features/posts/application/posts_state.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

const _posts = [
  Post(id: 1, authorId: 1, title: 'Flutter tips', body: 'Widget composition'),
  Post(id: 2, authorId: 2, title: 'Dart patterns', body: 'Sealed classes'),
  Post(id: 3, authorId: 1, title: 'Design tokens', body: 'SPACING scales'),
];

void main() {
  late _MockPostsRepository repository;

  setUp(() {
    repository = _MockPostsRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [postsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      postsControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  PostsState stateOf(ProviderContainer container) =>
      container.read(postsControllerProvider);

  PostsController controllerOf(ProviderContainer container) =>
      container.read(postsControllerProvider.notifier);

  group('initial load', () {
    test('exposes loading until the repository answers, then posts', () async {
      final completer = Completer<List<Post>>();
      when(() => repository.getPosts()).thenAnswer((_) => completer.future);

      final container = createContainer();

      expect(stateOf(container).isInitialLoading, isTrue);
      await pumpEventQueue();
      expect(stateOf(container).isInitialLoading, isTrue);
      expect(stateOf(container).posts, isEmpty);

      completer.complete(_posts);
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.isInitialLoading, isFalse);
      expect(state.posts, _posts);
      expect(state.failure, isNull);
    });

    test('exposes the typed failure and keeps posts empty on error', () async {
      when(() => repository.getPosts()).thenThrow(const NetworkFailure());

      final container = createContainer();
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.isInitialLoading, isFalse);
      expect(state.failure, isA<NetworkFailure>());
      expect(state.posts, isEmpty);
    });
  });

  group('retry', () {
    test('calls the repository again and replaces the error state', () async {
      var calls = 0;
      when(() => repository.getPosts()).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const TimeoutFailure();
        }
        return _posts;
      });

      final container = createContainer();
      await pumpEventQueue();
      expect(stateOf(container).failure, isA<TimeoutFailure>());

      await controllerOf(container).retry();

      final state = stateOf(container);
      expect(state.posts, _posts);
      expect(state.failure, isNull);
      verify(() => repository.getPosts()).called(2);
    });

    test('does not start a second request while one is pending', () async {
      final completer = Completer<List<Post>>();
      when(() => repository.getPosts()).thenAnswer((_) => completer.future);

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).retry();
      await pumpEventQueue();
      verify(() => repository.getPosts()).called(1);

      completer.complete(_posts);
      await pumpEventQueue();
      expect(stateOf(container).posts, _posts);
    });
  });

  group('refresh', () {
    test(
      'keeps old posts while pending and replaces them on success',
      () async {
        var calls = 0;
        final refreshCompleter = Completer<List<Post>>();
        when(() => repository.getPosts()).thenAnswer((_) {
          calls++;
          if (calls == 1) {
            return Future.value([_posts.first]);
          }
          return refreshCompleter.future;
        });

        final container = createContainer();
        await pumpEventQueue();
        expect(stateOf(container).posts, [_posts.first]);

        final refreshFuture = controllerOf(container).refresh();
        await pumpEventQueue();

        var state = stateOf(container);
        expect(state.isRefreshing, isTrue);
        expect(state.posts, [_posts.first]);
        expect(state.isInitialLoading, isFalse);

        refreshCompleter.complete(_posts);
        await refreshFuture;

        state = stateOf(container);
        expect(state.isRefreshing, isFalse);
        expect(state.posts, _posts);
        expect(state.failure, isNull);
      },
    );

    test('keeps previous posts and exposes the failure on error', () async {
      var calls = 0;
      when(() => repository.getPosts()).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          return [_posts.first];
        }
        throw const ServerFailure(statusCode: 500);
      });

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).refresh();

      final state = stateOf(container);
      expect(state.posts, [_posts.first]);
      expect(state.isRefreshing, isFalse);
      expect(
        state.failure,
        isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 500),
      );
    });

    test('ignores an overlapping refresh while one is pending', () async {
      var calls = 0;
      final refreshCompleter = Completer<List<Post>>();
      when(() => repository.getPosts()).thenAnswer((_) {
        calls++;
        if (calls == 1) {
          return Future.value([_posts.first]);
        }
        return refreshCompleter.future;
      });

      final container = createContainer();
      await pumpEventQueue();

      final first = controllerOf(container).refresh();
      final second = controllerOf(container).refresh();
      await second;

      refreshCompleter.complete(_posts);
      await first;

      verify(() => repository.getPosts()).called(2);
      expect(stateOf(container).posts, _posts);
    });
  });

  group('search', () {
    Future<ProviderContainer> loadedContainer() async {
      when(() => repository.getPosts()).thenAnswer((_) async => _posts);
      final container = createContainer();
      await pumpEventQueue();
      return container;
    }

    test('matches titles case-insensitively', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('FLUTTER');

      expect(stateOf(container).visiblePosts, [_posts[0]]);
    });

    test('matches body text case-insensitively', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('spacing');

      expect(stateOf(container).visiblePosts, [_posts[2]]);
    });

    test('trims surrounding whitespace from the query', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('  dart  ');

      expect(stateOf(container).visiblePosts, [_posts[1]]);
    });

    test('preserves original order for multiple matches', () async {
      final container = await loadedContainer();

      controllerOf(container).setQuery('s');

      expect(stateOf(container).visiblePosts.map((post) => post.id), [1, 2, 3]);
    });

    test(
      'clearing the query restores all posts without a repository call',
      () async {
        final container = await loadedContainer();

        controllerOf(container).setQuery('flutter');
        controllerOf(container).clearQuery();

        expect(stateOf(container).visiblePosts, _posts);
        verify(() => repository.getPosts()).called(1);
      },
    );
  });
}
