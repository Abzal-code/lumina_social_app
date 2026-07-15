import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/presentation/failure_messages.dart';
import '../../favorites/application/favorites_controller.dart';
import '../../favorites/application/favorites_state.dart';
import '../application/posts_controller.dart';
import '../application/posts_state.dart';
import 'widgets/post_card.dart';
import 'widgets/posts_empty_view.dart';
import 'widgets/posts_loading_view.dart';
import 'widgets/posts_search_field.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postsControllerProvider);
    final controller = ref.read(postsControllerProvider.notifier);

    ref.listen<PostsState>(postsControllerProvider, (previous, next) {
      final refreshFailed =
          (previous?.isRefreshing ?? false) &&
          !next.isRefreshing &&
          next.failure != null &&
          next.posts.isNotEmpty;
      if (refreshFailed) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.failure!.userMessage)));
      }
    });

    final hasInitialFailure = state.posts.isEmpty && state.failure != null;
    final showSearch = !state.isInitialLoading && !hasInitialFailure;

    return AppScaffold(
      title: 'Posts',
      body: AdaptiveContent(
        child: Column(
          children: [
            if (showSearch) ...[
              const SizedBox(height: AppSpacing.sm),
              PostsSearchField(
                query: state.query,
                onQueryChanged: controller.setQuery,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Expanded(
              child: _PostsContent(state: state, controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsContent extends ConsumerWidget {
  const _PostsContent({required this.state, required this.controller});

  final PostsState state;
  final PostsController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isInitialLoading) {
      return const PostsLoadingView();
    }
    if (state.posts.isEmpty && state.failure != null) {
      return _PostsErrorView(
        message: state.failure!.userMessage,
        onRetry: controller.retry,
      );
    }
    final favoritesState = ref.watch(favoritesControllerProvider);
    final favoritesNotifier = ref.read(favoritesControllerProvider.notifier);
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: _buildScrollableContent(favoritesState, favoritesNotifier),
    );
  }

  Widget _buildScrollableContent(
    FavoritesState favoritesState,
    FavoritesController favoritesNotifier,
  ) {
    if (state.posts.isEmpty) {
      return _fillViewport(const PostsEmptyView.noPosts());
    }
    final visiblePosts = state.visiblePosts;
    if (visiblePosts.isEmpty) {
      return _fillViewport(
        PostsEmptyView.noResults(onClearSearch: controller.clearQuery),
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: visiblePosts.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final post = visiblePosts[index];
        return PostCard(
          key: ValueKey(post.id),
          post: post,
          isFavorite: favoritesState.isFavorite(post.id),
          isFavoriteUpdating: favoritesState.updatingPostId == post.id,
          onFavoritePressed: favoritesState.canToggle
              ? () => favoritesNotifier.toggleFavorite(post.id)
              : null,
        );
      },
    );
  }

  Widget _fillViewport(Widget child) => CustomScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    slivers: [
      SliverFillRemaining(hasScrollBody: false, child: Center(child: child)),
    ],
  );
}

class _PostsErrorView extends StatelessWidget {
  const _PostsErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
              'Couldn’t load posts',
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
