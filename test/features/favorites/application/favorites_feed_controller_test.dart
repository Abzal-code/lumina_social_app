import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/favorites/application/favorites_controller.dart';
import 'package:lumina/features/favorites/application/favorites_feed_controller.dart';
import 'package:lumina/features/favorites/application/favorites_feed_state.dart';
import 'package:lumina/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:lumina/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lumina/features/posts/application/posts_controller.dart';
import 'package:lumina/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

class _MockPostsRepository extends Mock implements PostsRepository {}

Post _post(int id) =>
    Post(id: id, authorId: 1, title: 'Post $id', body: 'Body $id');

void main() {
  late _MockFavoritesRepository favoritesRepository;
  late _MockPostsRepository postsRepository;

  setUp(() {
    favoritesRepository = _MockFavoritesRepository();
    postsRepository = _MockPostsRepository();
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {});
    when(() => favoritesRepository.addFavorite(any())).thenAnswer((_) async {});
    when(
      () => favoritesRepository.removeFavorite(any()),
    ).thenAnswer((_) async {});
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
        postsRepositoryProvider.overrideWithValue(postsRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  ProviderContainer feedContainer() {
    final container = createContainer();
    final subscription = container.listen(
      favoritesFeedControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  FavoritesFeedState stateOf(ProviderContainer container) =>
      container.read(favoritesFeedControllerProvider);

  test('empty favorites resolve to an empty feed without network', () async {
    final container = feedContainer();
    await pumpEventQueue();

    final state = stateOf(container);
    expect(state.posts, isEmpty);
    expect(state.isLoading, isFalse);
    expect(state.failure, isNull);
    verifyNever(() => postsRepository.getPost(any()));
    verifyNever(() => postsRepository.getPosts());
  });

  test('reuses posts already loaded by the posts list', () async {
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {2});
    when(
      () => postsRepository.getPosts(),
    ).thenAnswer((_) async => [_post(1), _post(2)]);

    final container = createContainer();
    final postsSubscription = container.listen(
      postsControllerProvider,
      (previous, next) {},
    );
    addTearDown(postsSubscription.close);
    await pumpEventQueue();

    final feedSubscription = container.listen(
      favoritesFeedControllerProvider,
      (previous, next) {},
    );
    addTearDown(feedSubscription.close);
    await pumpEventQueue();

    expect(stateOf(container).posts, [_post(2)]);
    verifyNever(() => postsRepository.getPost(any()));
  });

  test('fetches missing posts through getPost', () async {
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {5});
    when(() => postsRepository.getPost(5)).thenAnswer((_) async => _post(5));

    final container = feedContainer();
    await pumpEventQueue();

    expect(stateOf(container).posts, [_post(5)]);
    verify(() => postsRepository.getPost(5)).called(1);
  });

  test('orders the feed by ascending post ID', () async {
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {3, 1, 2});
    for (final id in [1, 2, 3]) {
      when(
        () => postsRepository.getPost(id),
      ).thenAnswer((_) async => _post(id));
    }

    final container = feedContainer();
    await pumpEventQueue();

    expect(stateOf(container).posts.map((post) => post.id), [1, 2, 3]);
  });

  test('removing a favorite updates the feed without refetching', () async {
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {1, 2});
    for (final id in [1, 2]) {
      when(
        () => postsRepository.getPost(id),
      ).thenAnswer((_) async => _post(id));
    }

    final container = feedContainer();
    await pumpEventQueue();
    expect(stateOf(container).posts.length, 2);

    await container
        .read(favoritesControllerProvider.notifier)
        .toggleFavorite(2);
    await pumpEventQueue();

    expect(stateOf(container).posts, [_post(1)]);
    verify(() => postsRepository.getPost(any())).called(2);
  });

  test('exposes the resolution failure', () async {
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {5});
    when(
      () => postsRepository.getPost(5),
    ).thenThrow(const ServerFailure(statusCode: 500));

    final container = feedContainer();
    await pumpEventQueue();

    final state = stateOf(container);
    expect(state.failure, isA<ServerFailure>());
    expect(state.isLoading, isFalse);
  });

  test(
    'a missing favorite surfaces NotFoundFailure without crashing',
    () async {
      when(
        () => favoritesRepository.getFavoritePostIds(),
      ).thenAnswer((_) async => {404});
      when(
        () => postsRepository.getPost(404),
      ).thenThrow(const NotFoundFailure());

      final container = feedContainer();
      await pumpEventQueue();

      expect(stateOf(container).failure, isA<NotFoundFailure>());
    },
  );

  test('retry recovers from a resolution failure', () async {
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {5});
    var calls = 0;
    when(() => postsRepository.getPost(5)).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        throw const TimeoutFailure();
      }
      return _post(5);
    });

    final container = feedContainer();
    await pumpEventQueue();
    expect(stateOf(container).failure, isA<TimeoutFailure>());

    await container.read(favoritesFeedControllerProvider.notifier).retry();

    expect(stateOf(container).posts, [_post(5)]);
    expect(stateOf(container).failure, isNull);
  });

  test('retry recovers from a restore failure', () async {
    var restoreCalls = 0;
    when(() => favoritesRepository.getFavoritePostIds()).thenAnswer((_) async {
      restoreCalls++;
      if (restoreCalls == 1) {
        throw const DataParsingFailure();
      }
      return {5};
    });
    when(() => postsRepository.getPost(5)).thenAnswer((_) async => _post(5));

    final container = feedContainer();
    await pumpEventQueue();
    expect(stateOf(container).failure, isA<DataParsingFailure>());

    await container.read(favoritesFeedControllerProvider.notifier).retry();
    await pumpEventQueue();

    expect(stateOf(container).posts, [_post(5)]);
  });

  test(
    'applyPostUpdated refreshes cached content without refetching',
    () async {
      when(
        () => favoritesRepository.getFavoritePostIds(),
      ).thenAnswer((_) async => {1});
      when(() => postsRepository.getPost(1)).thenAnswer((_) async => _post(1));

      final container = feedContainer();
      await pumpEventQueue();
      expect(stateOf(container).posts, [_post(1)]);

      const edited = Post(id: 1, authorId: 1, title: 'Edited', body: 'eb');
      container
          .read(favoritesFeedControllerProvider.notifier)
          .applyPostUpdated(edited);

      expect(stateOf(container).posts, [edited]);
      verify(() => postsRepository.getPost(1)).called(1);
    },
  );

  test('applyPostUpdated ignores posts that are not cached', () async {
    final container = feedContainer();
    await pumpEventQueue();

    container
        .read(favoritesFeedControllerProvider.notifier)
        .applyPostUpdated(_post(9));

    expect(stateOf(container).posts, isEmpty);
  });

  test('applyPostDeleted drops the cached post', () async {
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {1, 2});
    for (final id in [1, 2]) {
      when(
        () => postsRepository.getPost(id),
      ).thenAnswer((_) async => _post(id));
    }

    final container = feedContainer();
    await pumpEventQueue();
    expect(stateOf(container).posts.length, 2);

    container
        .read(favoritesFeedControllerProvider.notifier)
        .applyPostDeleted(2);
    await container
        .read(favoritesControllerProvider.notifier)
        .removeFavorite(2);
    await pumpEventQueue();

    expect(stateOf(container).posts, [_post(1)]);
  });

  test('never fetches the same post twice', () async {
    when(
      () => favoritesRepository.getFavoritePostIds(),
    ).thenAnswer((_) async => {1});
    for (final id in [1, 2]) {
      when(
        () => postsRepository.getPost(id),
      ).thenAnswer((_) async => _post(id));
    }

    final container = feedContainer();
    await pumpEventQueue();
    expect(stateOf(container).posts, [_post(1)]);

    await container
        .read(favoritesControllerProvider.notifier)
        .toggleFavorite(2);
    await pumpEventQueue();

    expect(stateOf(container).posts, [_post(1), _post(2)]);
    verify(() => postsRepository.getPost(1)).called(1);
    verify(() => postsRepository.getPost(2)).called(1);
  });
}
