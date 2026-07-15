import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/presentation/failure_messages.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../posts/presentation/widgets/post_card.dart';
import '../../posts/presentation/widgets/posts_loading_view.dart';
import '../application/favorites_controller.dart';
import '../application/favorites_feed_controller.dart';
import '../application/favorites_feed_state.dart';
import '../application/favorites_state.dart';
import 'widgets/favorites_empty_view.dart';

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
      return _FavoritesErrorView(
        message: failure.userMessage,
        onRetry: onRetry,
      );
    }
    if (feedState.posts.isEmpty) {
      return const Center(
        child: SingleChildScrollView(child: FavoritesEmptyView()),
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

class _FavoritesErrorView extends StatelessWidget {
  const _FavoritesErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 56, color: colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Couldn’t load favorites',
              style: textTheme.titleLarge,
              textAlign: .center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: .center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
