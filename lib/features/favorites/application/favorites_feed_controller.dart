import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../../posts/application/posts_controller.dart';
import '../../posts/data/repositories/posts_repository_impl.dart';
import '../../posts/domain/entities/post.dart';
import 'favorites_controller.dart';
import 'favorites_feed_state.dart';

part 'favorites_feed_controller.g.dart';

/// Resolves favorite IDs into cached posts ordered by post ID.
@riverpod
class FavoritesFeedController extends _$FavoritesFeedController {
  final Map<int, Post> _resolvedPosts = {};
  bool _resolveInFlight = false;

  @override
  FavoritesFeedState build() {
    final favorites = ref.watch(
      favoritesControllerProvider.select(
        (favoritesState) => (
          ids: favoritesState.favoritePostIds,
          isRestoring: favoritesState.isInitialLoading,
          restoreFailure: favoritesState.failure,
        ),
      ),
    );

    if (favorites.isRestoring) {
      return const FavoritesFeedState(isLoading: true);
    }
    final restoreFailure = favorites.restoreFailure;
    if (restoreFailure != null) {
      return FavoritesFeedState(failure: restoreFailure);
    }

    final sortedIds = favorites.ids.toList()..sort();
    final hasMissingPosts = sortedIds.any(
      (id) => !_resolvedPosts.containsKey(id),
    );
    if (!hasMissingPosts) {
      return FavoritesFeedState(
        posts: [for (final id in sortedIds) _resolvedPosts[id]!],
      );
    }
    Future.microtask(_resolvePosts);
    return const FavoritesFeedState(isLoading: true);
  }

  Future<void> retry() async {
    if (ref.read(favoritesControllerProvider).failure != null) {
      await ref.read(favoritesControllerProvider.notifier).retry();
      return;
    }
    await _resolvePosts();
  }

  void applyPostUpdated(Post post) {
    if (!_resolvedPosts.containsKey(post.id)) {
      return;
    }
    _resolvedPosts[post.id] = post;
    state = state.copyWith(
      posts: [
        for (final existing in state.posts)
          existing.id == post.id ? post : existing,
      ],
    );
  }

  void applyPostDeleted(int postId) {
    _resolvedPosts.remove(postId);
  }

  Future<void> _resolvePosts() async {
    if (_resolveInFlight) {
      return;
    }
    _resolveInFlight = true;
    try {
      _reuseAlreadyLoadedPosts();
      // Favorites may change while posts are being fetched; loop until the
      // current ID set is fully resolved.
      while (true) {
        final sortedIds =
            ref.read(favoritesControllerProvider).favoritePostIds.toList()
              ..sort();
        final missingIds = [
          for (final id in sortedIds)
            if (!_resolvedPosts.containsKey(id)) id,
        ];
        if (missingIds.isEmpty) {
          state = FavoritesFeedState(
            posts: [for (final id in sortedIds) _resolvedPosts[id]!],
          );
          return;
        }
        state = state.copyWith(isLoading: true, failure: null);
        for (final id in missingIds) {
          final post = await ref.read(postsRepositoryProvider).getPost(id);
          if (!ref.mounted) return;
          _resolvedPosts[id] = post;
        }
      }
    } on AppFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, failure: failure);
    } catch (_) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
      rethrow;
    } finally {
      _resolveInFlight = false;
    }
  }

  void _reuseAlreadyLoadedPosts() {
    if (!ref.exists(postsControllerProvider)) {
      return;
    }
    for (final post in ref.read(postsControllerProvider).posts) {
      _resolvedPosts[post.id] = post;
    }
  }
}
