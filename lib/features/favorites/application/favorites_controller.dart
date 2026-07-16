import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../data/repositories/favorites_repository_impl.dart';
import 'favorites_state.dart';

part 'favorites_controller.g.dart';

/// Kept alive so favorites restore once and stay in sync across all tabs.
@Riverpod(keepAlive: true)
class FavoritesController extends _$FavoritesController {
  bool _loadInFlight = false;

  @override
  FavoritesState build() {
    Future.microtask(_loadFavorites);
    return const FavoritesState(isInitialLoading: true);
  }

  Future<void> retry() => _loadFavorites();

  /// Applies the toggle optimistically and rolls back on persistence failure.
  Future<void> toggleFavorite(int postId) async {
    if (postId <= 0 || !state.canToggle || state.isUpdating) {
      return;
    }
    final previousIds = state.favoritePostIds;
    final isCurrentlyFavorite = previousIds.contains(postId);
    final updatedIds = isCurrentlyFavorite
        ? (<int>{...previousIds}..remove(postId))
        : <int>{...previousIds, postId};
    state = state.copyWith(
      favoritePostIds: updatedIds,
      updatingPostId: postId,
      toggleFailure: null,
    );
    try {
      final repository = ref.read(favoritesRepositoryProvider);
      if (isCurrentlyFavorite) {
        await repository.removeFavorite(postId);
      } else {
        await repository.addFavorite(postId);
      }
      if (!ref.mounted) return;
      state = state.copyWith(updatingPostId: null);
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(
        favoritePostIds: previousIds,
        updatingPostId: null,
        toggleFailure: failure,
      );
    } catch (_) {
      if (ref.mounted) {
        state = state.copyWith(
          favoritePostIds: previousIds,
          updatingPostId: null,
        );
      }
      rethrow;
    }
  }

  /// Removes [postId] from favorites with the same optimistic/rollback
  /// guarantees as [toggleFavorite]; no-ops when the post is not a favorite.
  Future<void> removeFavorite(int postId) async {
    if (!state.favoritePostIds.contains(postId)) {
      return;
    }
    await toggleFavorite(postId);
  }

  Future<void> _loadFavorites() async {
    if (_loadInFlight || state.isUpdating) {
      return;
    }
    _loadInFlight = true;
    state = state.copyWith(isInitialLoading: true, failure: null);
    try {
      final ids = await ref
          .read(favoritesRepositoryProvider)
          .getFavoritePostIds();
      if (!ref.mounted) return;
      state = state.copyWith(
        favoritePostIds: ids,
        isInitialLoading: false,
        failure: null,
      );
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(isInitialLoading: false, failure: failure);
    } finally {
      _loadInFlight = false;
    }
  }
}
