import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/favorites/application/favorites_controller.dart';
import 'package:lumina/features/favorites/application/favorites_state.dart';
import 'package:lumina/features/favorites/di.dart';
import 'package:lumina/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late _MockFavoritesRepository repository;

  setUp(() {
    repository = _MockFavoritesRepository();
    when(() => repository.getFavoritePostIds()).thenAnswer((_) async => {});
    when(() => repository.addFavorite(any())).thenAnswer((_) async {});
    when(() => repository.removeFavorite(any())).thenAnswer((_) async {});
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [favoritesRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      favoritesControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    return container;
  }

  FavoritesState stateOf(ProviderContainer container) =>
      container.read(favoritesControllerProvider);

  FavoritesController controllerOf(ProviderContainer container) =>
      container.read(favoritesControllerProvider.notifier);

  group('initial load', () {
    test('restores persisted IDs', () async {
      when(
        () => repository.getFavoritePostIds(),
      ).thenAnswer((_) async => {2, 1});

      final container = createContainer();
      expect(stateOf(container).isInitialLoading, isTrue);
      expect(stateOf(container).canToggle, isFalse);
      await pumpEventQueue();

      final state = stateOf(container);
      expect(state.favoritePostIds, {1, 2});
      expect(state.isInitialLoading, isFalse);
      expect(state.isFavorite(1), isTrue);
      expect(state.isFavorite(3), isFalse);
      expect(state.canToggle, isTrue);
    });

    test('exposes the failure and blocks toggles until retry', () async {
      var calls = 0;
      when(() => repository.getFavoritePostIds()).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const DataParsingFailure();
        }
        return {7};
      });

      final container = createContainer();
      await pumpEventQueue();

      expect(stateOf(container).failure, isA<DataParsingFailure>());
      expect(stateOf(container).canToggle, isFalse);

      await controllerOf(container).toggleFavorite(1);
      verifyNever(() => repository.addFavorite(any()));

      await controllerOf(container).retry();
      expect(stateOf(container).favoritePostIds, {7});
      expect(stateOf(container).canToggle, isTrue);
    });
  });

  group('toggleFavorite add', () {
    test(
      'updates the set optimistically before persistence finishes',
      () async {
        final completer = Completer<void>();
        when(
          () => repository.addFavorite(1),
        ).thenAnswer((_) => completer.future);

        final container = createContainer();
        await pumpEventQueue();

        final toggleFuture = controllerOf(container).toggleFavorite(1);

        expect(stateOf(container).isFavorite(1), isTrue);
        expect(stateOf(container).updatingPostId, 1);

        completer.complete();
        await toggleFuture;

        expect(stateOf(container).isFavorite(1), isTrue);
        expect(stateOf(container).updatingPostId, isNull);
        expect(stateOf(container).toggleFailure, isNull);
      },
    );

    test('rolls back when persistence fails', () async {
      when(
        () => repository.addFavorite(1),
      ).thenThrow(const UnexpectedFailure());

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).toggleFavorite(1);

      final state = stateOf(container);
      expect(state.isFavorite(1), isFalse);
      expect(state.toggleFailure, isA<UnexpectedFailure>());
      expect(state.updatingPostId, isNull);
    });

    test('bookmarks a locally created post by its negative ID', () async {
      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).toggleFavorite(-3);

      expect(stateOf(container).isFavorite(-3), isTrue);
      verify(() => repository.addFavorite(-3)).called(1);
    });
  });

  group('toggleFavorite remove', () {
    setUp(() {
      when(
        () => repository.getFavoritePostIds(),
      ).thenAnswer((_) async => {1, 2});
    });

    test('removes optimistically and persists', () async {
      final completer = Completer<void>();
      when(
        () => repository.removeFavorite(2),
      ).thenAnswer((_) => completer.future);

      final container = createContainer();
      await pumpEventQueue();

      final toggleFuture = controllerOf(container).toggleFavorite(2);

      expect(stateOf(container).isFavorite(2), isFalse);

      completer.complete();
      await toggleFuture;

      expect(stateOf(container).favoritePostIds, {1});
      verify(() => repository.removeFavorite(2)).called(1);
    });

    test('rolls back the removal when persistence fails', () async {
      when(
        () => repository.removeFavorite(2),
      ).thenThrow(const UnexpectedFailure());

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).toggleFavorite(2);

      expect(stateOf(container).favoritePostIds, {1, 2});
      expect(stateOf(container).toggleFailure, isA<UnexpectedFailure>());
    });
  });

  group('concurrency', () {
    test(
      'ignores a duplicate toggle for the same post while pending',
      () async {
        final completer = Completer<void>();
        when(
          () => repository.addFavorite(1),
        ).thenAnswer((_) => completer.future);

        final container = createContainer();
        await pumpEventQueue();

        final first = controllerOf(container).toggleFavorite(1);
        await controllerOf(container).toggleFavorite(1);

        completer.complete();
        await first;

        verify(() => repository.addFavorite(1)).called(1);
        verifyNever(() => repository.removeFavorite(any()));
        expect(stateOf(container).isFavorite(1), isTrue);
      },
    );

    test('ignores a toggle for another post while one is pending', () async {
      final completer = Completer<void>();
      when(() => repository.addFavorite(1)).thenAnswer((_) => completer.future);

      final container = createContainer();
      await pumpEventQueue();

      final first = controllerOf(container).toggleFavorite(1);
      await controllerOf(container).toggleFavorite(2);

      expect(stateOf(container).isFavorite(2), isFalse);
      verifyNever(() => repository.addFavorite(2));

      completer.complete();
      await first;

      expect(stateOf(container).isFavorite(1), isTrue);
      expect(stateOf(container).isFavorite(2), isFalse);
    });
  });

  group('toggle failures', () {
    test('a new toggle clears the stale failure', () async {
      when(
        () => repository.addFavorite(1),
      ).thenThrow(const UnexpectedFailure());

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).toggleFavorite(1);
      expect(stateOf(container).toggleFailure, isA<UnexpectedFailure>());

      final completer = Completer<void>();
      when(() => repository.addFavorite(2)).thenAnswer((_) => completer.future);
      final toggleFuture = controllerOf(container).toggleFavorite(2);

      expect(stateOf(container).toggleFailure, isNull);

      completer.complete();
      await toggleFuture;
      expect(stateOf(container).toggleFailure, isNull);
    });
  });

  group('invalid IDs', () {
    test('ignores the zero sentinel without calling the repository', () async {
      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).toggleFavorite(0);

      verifyNever(() => repository.addFavorite(any()));
      verifyNever(() => repository.removeFavorite(any()));
      expect(stateOf(container).favoritePostIds, isEmpty);
    });
  });

  group('removeFavorite', () {
    test('removes and persists an existing favorite', () async {
      when(
        () => repository.getFavoritePostIds(),
      ).thenAnswer((_) async => {1, 2});

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).removeFavorite(2);

      expect(stateOf(container).favoritePostIds, {1});
      verify(() => repository.removeFavorite(2)).called(1);
    });

    test('no-ops when the post is not a favorite', () async {
      when(() => repository.getFavoritePostIds()).thenAnswer((_) async => {1});

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).removeFavorite(5);

      expect(stateOf(container).favoritePostIds, {1});
      verifyNever(() => repository.removeFavorite(any()));
    });

    test('rolls back and exposes the failure when persistence fails', () async {
      when(() => repository.getFavoritePostIds()).thenAnswer((_) async => {2});
      when(
        () => repository.removeFavorite(2),
      ).thenThrow(const UnexpectedFailure());

      final container = createContainer();
      await pumpEventQueue();

      await controllerOf(container).removeFavorite(2);

      final state = stateOf(container);
      expect(state.favoritePostIds, {2});
      expect(state.toggleFailure, isA<UnexpectedFailure>());
    });
  });
}
