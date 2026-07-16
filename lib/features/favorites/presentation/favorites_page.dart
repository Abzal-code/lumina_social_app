import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/presentation/failure_messages.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../posts/presentation/widgets/post_card.dart';
import '../../posts/presentation/widgets/posts_loading_view.dart';
import '../application/favorites_controller.dart';
import '../application/favorites_feed_controller.dart';
import '../application/favorites_feed_state.dart';
import '../application/favorites_state.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(favoritesFeedControllerProvider);
    final feedController = ref.read(favoritesFeedControllerProvider.notifier);
    final favoritesState = ref.watch(favoritesControllerProvider);
    final favoritesNotifier = ref.read(favoritesControllerProvider.notifier);

    return AppScaffold(
      title: 'Favorites',
      body: AdaptiveContent(
        child: _FavoritesContent(
          feedState: feedState,
          favoritesState: favoritesState,
          onRetry: feedController.retry,
          onToggleFavorite: favoritesNotifier.toggleFavorite,
        ),
      ),
    );
  }
}

class _FavoritesContent extends StatelessWidget {
  const _FavoritesContent({
    required this.feedState,
    required this.favoritesState,
    required this.onRetry,
    required this.onToggleFavorite,
  });

  final FavoritesFeedState feedState;
  final FavoritesState favoritesState;
  final Future<void> Function() onRetry;
  final void Function(int postId) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    if (feedState.isLoading && feedState.posts.isEmpty) {
      return const PostsLoadingView();
    }
    final failure = feedState.failure;
    if (failure != null && feedState.posts.isEmpty) {
      return ErrorStateView(
        title: 'Couldn’t load favorites',
        message: failure.userMessage,
        onRetry: onRetry,
      );
    }
    if (feedState.posts.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: EmptyStateView(
            icon: Icons.bookmark_outline,
            title: 'No favorites yet',
            message:
                'Bookmark posts you want to revisit and they will appear here.',
            action: FilledButton(
              onPressed: () => context.go(AppRoutes.posts),
              child: const Text('Browse posts'),
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg),
      itemCount: feedState.posts.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final post = feedState.posts[index];
        return PostCard(
          key: ValueKey(post.id),
          post: post,
          isFavorite: favoritesState.isFavorite(post.id),
          isFavoriteUpdating: favoritesState.updatingPostId == post.id,
          onFavoritePressed: favoritesState.canToggle
              ? () => onToggleFavorite(post.id)
              : null,
        );
      },
    );
  }
}

