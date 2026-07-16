import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/favorites/application/favorites_controller.dart';
import 'package:lumina/features/favorites/application/favorites_feed_controller.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lumina/features/posts/application/delete_post_controller.dart';
import 'package:lumina/features/posts/application/posts_controller.dart';
import 'package:lumina/features/posts/di.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:lumina/features/posts/domain/repositories/posts_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_repositories.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

const _posts = [
  Post(id: 1, authorId: 1, title: 'First', body: 'first body'),
  Post(id: 2, authorId: 2, title: 'Second', body: 'second body'),
];

void main() {
  late _MockPostsRepository repository;
  late FakeFavoritesRepository favoritesRepository;

  setUp(() {
    repository = _MockPostsRepository();
    favoritesRepository = FakeFavoritesRepository(initialIds: {2});
    when(() => repository.getPosts()).thenAnswer((_) async => _posts);
    when(() => repository.deletePost(any())).thenAnswer((_) async {});
  });

  ProviderContainer createContainer({FavoritesRepository? favorites}) {
    final container = ProviderContainer(
      overrides: [
        postsRepositoryProvider.overrideWithValue(repository),
        favoritesRepositoryProvider.overrideWithValue(
          favorites ?? favoritesRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      deletePostControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  DeletePostController controllerOf(ProviderContainer container) =>
      container.read(deletePostControllerProvider.notifier);

  test('a successful delete calls the repository and resets state', () async {
    final container = createContainer();

    final deleted = await controllerOf(container).deletePost(2);

    expect(deleted, isTrue);
    final state = container.read(deletePostControllerProvider);
    expect(state.isDeleting, isFalse);
    expect(state.failure, isNull);
    verify(() => repository.deletePost(2)).called(1);
  });

  test('a failed delete exposes the failure and returns false', () async {
    when(() => repository.deletePost(2)).thenThrow(const NetworkFailure());
    final container = createContainer();

    final deleted = await controllerOf(container).deletePost(2);

    expect(deleted, isFalse);
    final state = container.read(deletePostControllerProvider);
    expect(state.isDeleting, isFalse);
    expect(state.failure, isA<NetworkFailure>());
  });

  test('blocks a duplicate delete while one is in flight', () async {
    final completer = Completer<void>();
    when(() => repository.deletePost(2)).thenAnswer((_) => completer.future);
    final container = createContainer();

    final first = controllerOf(container).deletePost(2);
    final second = await controllerOf(container).deletePost(2);

    expect(second, isFalse);
    completer.complete();
    expect(await first, isTrue);
    verify(() => repository.deletePost(2)).called(1);
  });

  test('an unexpected error clears the in-flight state and rethrows', () async {
    when(() => repository.deletePost(2)).thenThrow(StateError('bug'));
    final container = createContainer();

    await expectLater(controllerOf(container).deletePost(2), throwsStateError);
    expect(container.read(deletePostControllerProvider).isDeleting, isFalse);
  });

  test('deleting a favorited post removes and persists the favorite', () async {
    final container = createContainer();
    final favoritesSubscription = container.listen(
      favoritesControllerProvider,
      (previous, next) {},
    );
    addTearDown(favoritesSubscription.close);
    await pumpEventQueue();
    expect(container.read(favoritesControllerProvider).isFavorite(2), isTrue);

    await controllerOf(container).deletePost(2);
    await pumpEventQueue();

    expect(container.read(favoritesControllerProvider).isFavorite(2), isFalse);
    expect(await favoritesRepository.getFavoritePostIds(), isEmpty);
  });

  test('deleting a favorited locally created post removes and persists the '
      'favorite', () async {
    favoritesRepository = FakeFavoritesRepository(initialIds: {-1});
    final container = createContainer();
    final favoritesSubscription = container.listen(
      favoritesControllerProvider,
      (previous, next) {},
    );
    addTearDown(favoritesSubscription.close);
    await pumpEventQueue();
    expect(container.read(favoritesControllerProvider).isFavorite(-1), isTrue);

    await controllerOf(container).deletePost(-1);
    await pumpEventQueue();

    expect(container.read(favoritesControllerProvider).isFavorite(-1), isFalse);
    expect(await favoritesRepository.getFavoritePostIds(), isEmpty);
  });

  test('deleting a non-favorited post leaves favorites untouched', () async {
    final container = createContainer();
    final favoritesSubscription = container.listen(
      favoritesControllerProvider,
      (previous, next) {},
    );
    addTearDown(favoritesSubscription.close);
    await pumpEventQueue();

    await controllerOf(container).deletePost(1);
    await pumpEventQueue();

    expect(container.read(favoritesControllerProvider).isFavorite(2), isTrue);
    expect(await favoritesRepository.getFavoritePostIds(), {2});
  });

  test('a favorite-removal failure keeps the delete successful and rolls the '
      'favorite back', () async {
    final failingFavorites = _MockFavoritesRepository();
    when(
      () => failingFavorites.getFavoritePostIds(),
    ).thenAnswer((_) async => {2});
    when(
      () => failingFavorites.removeFavorite(2),
    ).thenThrow(const UnexpectedFailure());
    final container = createContainer(favorites: failingFavorites);
    final favoritesSubscription = container.listen(
      favoritesControllerProvider,
      (previous, next) {},
    );
    addTearDown(favoritesSubscription.close);
    await pumpEventQueue();

    final deleted = await controllerOf(container).deletePost(2);
    await pumpEventQueue();

    expect(deleted, isTrue);
    final favoritesState = container.read(favoritesControllerProvider);
    expect(favoritesState.isFavorite(2), isTrue);
    expect(favoritesState.toggleFailure, isA<UnexpectedFailure>());
  });

  test('a deleted post disappears from an active PostsController', () async {
    final container = createContainer();
    final postsSubscription = container.listen(
      postsControllerProvider,
      (previous, next) {},
    );
    addTearDown(postsSubscription.close);
    await pumpEventQueue();
    expect(container.read(postsControllerProvider).posts.length, 2);

    await controllerOf(container).deletePost(2);

    expect(container.read(postsControllerProvider).posts, [_posts[0]]);
  });

  test('a deleted favorite disappears from the favorites feed', () async {
    when(() => repository.getPost(2)).thenAnswer((_) async => _posts[1]);
    final container = createContainer();
    final feedSubscription = container.listen(
      favoritesFeedControllerProvider,
      (previous, next) {},
    );
    addTearDown(feedSubscription.close);
    await pumpEventQueue();
    expect(container.read(favoritesFeedControllerProvider).posts, [_posts[1]]);

    await controllerOf(container).deletePost(2);
    await pumpEventQueue();

    expect(container.read(favoritesFeedControllerProvider).posts, isEmpty);
  });
}
