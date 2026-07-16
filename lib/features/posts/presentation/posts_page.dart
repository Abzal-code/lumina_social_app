import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/presentation/failure_messages.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../favorites/application/favorites_controller.dart';
import '../../favorites/application/favorites_state.dart';
import '../application/posts_controller.dart';
import '../application/posts_state.dart';
import 'widgets/post_card.dart';
import 'widgets/posts_loading_view.dart';

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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create post',
        onPressed: () => context.push(AppRoutes.postCreate),
        child: const Icon(Icons.add),
      ),
      body: AdaptiveContent(
        child: Column(
          children: [
            if (showSearch) ...[
              const SizedBox(height: AppSpacing.sm),
              AppSearchField(
                hintText: 'Search posts',
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
      return ErrorStateView(
        title: 'Couldn’t load posts',
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
      return _fillViewport(
        const EmptyStateView(
          icon: Icons.inbox_outlined,
          title: 'Nothing here yet',
          message: 'New posts will appear here as soon as they are published.',
        ),
      );
    }
    final visiblePosts = state.visiblePosts;
    if (visiblePosts.isEmpty) {
      return _fillViewport(
        EmptyStateView(
          icon: Icons.search_off,
          title: 'No matching posts',
          message: 'Try a different search term.',
          action: OutlinedButton(
            onPressed: controller.clearQuery,
            child: const Text('Clear search'),
          ),
        ),
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
