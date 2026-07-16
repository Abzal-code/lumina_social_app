import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/comments/di.dart';
import 'package:lumina/features/comments/domain/repositories/comments_repository.dart';
import 'package:lumina/features/favorites/application/favorites_feed_controller.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/posts/application/post_details_controller.dart';
import 'package:lumina/features/posts/application/post_form_controller.dart';
import 'package:lumina/features/posts/application/posts_controller.dart';
import 'package:lumina/features/posts/di.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:lumina/features/users/application/user_profile_controller.dart';
import 'package:lumina/features/users/di.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

class _MockCommentsRepository extends Mock implements CommentsRepository {}

const _posts = [
  Post(id: 1, authorId: 1, title: 'First', body: 'first body'),
  Post(id: 2, authorId: 2, title: 'Second', body: 'second body'),
];

const _created = Post(id: -1, authorId: 1, title: 'Created', body: 'new body');

void main() {
  late _MockPostsRepository repository;
  late _MockCommentsRepository commentsRepository;

  setUp(() {
    repository = _MockPostsRepository();
    commentsRepository = _MockCommentsRepository();
    when(() => repository.getPosts()).thenAnswer((_) async => _posts);
    when(
      () => commentsRepository.getCommentsForPost(any()),
    ).thenAnswer((_) async => const []);
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        postsRepositoryProvider.overrideWithValue(repository),
        commentsRepositoryProvider.overrideWithValue(commentsRepository),
        favoritesRepositoryProvider.overrideWithValue(
          FakeFavoritesRepository(),
        ),
        usersRepositoryProvider.overrideWithValue(FakeUsersRepository()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  ProviderContainer formContainer(int? postId) {
    final container = createContainer();
    final subscription = container.listen(
      postFormControllerProvider(postId),
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  group('create', () {
    test('returns the created post and clears the submitting flag', () async {
      when(
        () => repository.createPost(
          authorId: 1,
          title: 'Created',
          body: 'new body',
        ),
      ).thenAnswer((_) async => _created);

      final container = formContainer(null);
      final post = await container
          .read(postFormControllerProvider(null).notifier)
          .submit(authorId: 1, title: 'Created', body: 'new body');

      expect(post, _created);
      final state = container.read(postFormControllerProvider(null));
      expect(state.isSubmitting, isFalse);
      expect(state.submitFailure, isNull);
    });

    test('a created post appears first in an active PostsController', () async {
      when(
        () => repository.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _created);

      final container = formContainer(null);
      final postsSubscription = container.listen(
        postsControllerProvider,
        (previous, next) {},
      );
      addTearDown(postsSubscription.close);
      await pumpEventQueue();

      await container
          .read(postFormControllerProvider(null).notifier)
          .submit(authorId: 1, title: 'Created', body: 'new body');

      final postsState = container.read(postsControllerProvider);
      expect(postsState.posts.map((post) => post.id), [-1, 1, 2]);
      verify(() => repository.getPosts()).called(1);
    });

    test('search matches a created post through the query filter', () async {
      when(
        () => repository.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => _created);

      final container = formContainer(null);
      final postsSubscription = container.listen(
        postsControllerProvider,
        (previous, next) {},
      );
      addTearDown(postsSubscription.close);
      await pumpEventQueue();
      container.read(postsControllerProvider.notifier).setQuery('created');

      await container
          .read(postFormControllerProvider(null).notifier)
          .submit(authorId: 1, title: 'Created', body: 'new body');

      expect(container.read(postsControllerProvider).visiblePosts, [_created]);
    });

    test('exposes the failure and keeps no submitting state', () async {
      when(
        () => repository.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenThrow(const NetworkFailure());

      final container = formContainer(null);
      final post = await container
          .read(postFormControllerProvider(null).notifier)
          .submit(authorId: 1, title: 't', body: 'b');

      expect(post, isNull);
      final state = container.read(postFormControllerProvider(null));
      expect(state.isSubmitting, isFalse);
      expect(state.submitFailure, isA<NetworkFailure>());
    });

    test('a failed submit clears the stale failure on retry', () async {
      var calls = 0;
      when(
        () => repository.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const TimeoutFailure();
        }
        return _created;
      });

      final container = formContainer(null);
      final controller = container.read(
        postFormControllerProvider(null).notifier,
      );
      await controller.submit(authorId: 1, title: 't', body: 'b');
      expect(
        container.read(postFormControllerProvider(null)).submitFailure,
        isA<TimeoutFailure>(),
      );

      final post = await controller.submit(authorId: 1, title: 't', body: 'b');

      expect(post, _created);
      expect(
        container.read(postFormControllerProvider(null)).submitFailure,
        isNull,
      );
    });

    test('blocks a duplicate submit while one is in flight', () async {
      final completer = Completer<Post>();
      when(
        () => repository.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) => completer.future);

      final container = formContainer(null);
      final controller = container.read(
        postFormControllerProvider(null).notifier,
      );

      final first = controller.submit(authorId: 1, title: 't', body: 'b');
      final second = await controller.submit(
        authorId: 1,
        title: 't',
        body: 'b',
      );

      expect(second, isNull);
      completer.complete(_created);
      expect(await first, _created);
      verify(
        () => repository.createPost(
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).called(1);
    });

    test(
      'an unexpected error clears the in-flight state and rethrows',
      () async {
        when(
          () => repository.createPost(
            authorId: any(named: 'authorId'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          ),
        ).thenThrow(StateError('bug'));

        final container = formContainer(null);
        final controller = container.read(
          postFormControllerProvider(null).notifier,
        );

        await expectLater(
          controller.submit(authorId: 1, title: 't', body: 'b'),
          throwsStateError,
        );
        expect(
          container.read(postFormControllerProvider(null)).isSubmitting,
          isFalse,
        );
      },
    );
  });

  group('edit', () {
    test('prefills by loading the post for the given ID', () async {
      when(() => repository.getPost(2)).thenAnswer((_) async => _posts[1]);

      final container = formContainer(2);
      await pumpEventQueue();

      final state = container.read(postFormControllerProvider(2));
      expect(state.initialPost, _posts[1]);
      expect(state.isLoadingPost, isFalse);
    });

    test('exposes a load failure and recovers via retryLoad', () async {
      var calls = 0;
      when(() => repository.getPost(2)).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const NetworkFailure();
        }
        return _posts[1];
      });

      final container = formContainer(2);
      await pumpEventQueue();
      expect(
        container.read(postFormControllerProvider(2)).loadFailure,
        isA<NetworkFailure>(),
      );

      await container.read(postFormControllerProvider(2).notifier).retryLoad();

      expect(
        container.read(postFormControllerProvider(2)).initialPost,
        _posts[1],
      );
    });

    test('updates propagate to posts list, details, and feed', () async {
      const edited = Post(id: 2, authorId: 2, title: 'Edited', body: 'eb');
      when(() => repository.getPost(2)).thenAnswer((_) async => _posts[1]);
      when(
        () => repository.updatePost(
          postId: 2,
          authorId: 2,
          title: 'Edited',
          body: 'eb',
        ),
      ).thenAnswer((_) async => edited);

      final container = formContainer(2);
      final postsSubscription = container.listen(
        postsControllerProvider,
        (previous, next) {},
      );
      addTearDown(postsSubscription.close);
      final detailsSubscription = container.listen(
        postDetailsControllerProvider(2),
        (previous, next) {},
      );
      addTearDown(detailsSubscription.close);
      final feedSubscription = container.listen(
        favoritesFeedControllerProvider,
        (previous, next) {},
      );
      addTearDown(feedSubscription.close);
      await pumpEventQueue();

      final post = await container
          .read(postFormControllerProvider(2).notifier)
          .submit(authorId: 2, title: 'Edited', body: 'eb');

      expect(post, edited);
      expect(container.read(postsControllerProvider).posts, [
        _posts[0],
        edited,
      ]);
      expect(container.read(postDetailsControllerProvider(2)).post, edited);
    });

    test('an edit failure keeps the form state and exposes it', () async {
      when(() => repository.getPost(2)).thenAnswer((_) async => _posts[1]);
      when(
        () => repository.updatePost(
          postId: any(named: 'postId'),
          authorId: any(named: 'authorId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenThrow(const ServerFailure(statusCode: 500));

      final container = formContainer(2);
      await pumpEventQueue();

      final post = await container
          .read(postFormControllerProvider(2).notifier)
          .submit(authorId: 2, title: 't', body: 'b');

      expect(post, isNull);
      final state = container.read(postFormControllerProvider(2));
      expect(state.submitFailure, isA<ServerFailure>());
      expect(state.initialPost, _posts[1]);
    });

    test('an edit refreshes active user profiles', () async {
      const edited = Post(id: 2, authorId: 2, title: 'Edited', body: 'eb');
      when(() => repository.getPost(2)).thenAnswer((_) async => _posts[1]);
      when(
        () => repository.getPostsForUser(2),
      ).thenAnswer((_) async => [_posts[1]]);
      when(
        () => repository.updatePost(
          postId: 2,
          authorId: 2,
          title: 'Edited',
          body: 'eb',
        ),
      ).thenAnswer((_) async => edited);

      final container = formContainer(2);
      final profileSubscription = container.listen(
        userProfileControllerProvider(2),
        (previous, next) {},
      );
      addTearDown(profileSubscription.close);
      await pumpEventQueue();
      expect(container.read(userProfileControllerProvider(2)).posts, [
        _posts[1],
      ]);
      when(
        () => repository.getPostsForUser(2),
      ).thenAnswer((_) async => [edited]);

      await container
          .read(postFormControllerProvider(2).notifier)
          .submit(authorId: 2, title: 'Edited', body: 'eb');
      await pumpEventQueue();

      expect(container.read(userProfileControllerProvider(2)).posts, [edited]);
    });
  });
}
