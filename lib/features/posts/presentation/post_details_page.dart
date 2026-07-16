import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/presentation/failure_messages.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/skeleton_bar.dart';
import '../../comments/presentation/widgets/comment_card.dart';
import '../../comments/presentation/widgets/comments_empty_view.dart';
import '../../comments/presentation/widgets/comments_loading_view.dart';
import '../../favorites/application/favorites_controller.dart';
import '../../favorites/presentation/widgets/favorite_icon_button.dart';
import '../application/delete_post_controller.dart';
import '../application/post_details_controller.dart';
import '../application/post_details_state.dart';
import '../domain/entities/post.dart';
import 'widgets/delete_post_dialog.dart';

class PostDetailsPage extends ConsumerWidget {
  const PostDetailsPage({super.key, required this.postId});

  final int postId;

  Future<void> _deletePost(
    BuildContext context,
    WidgetRef ref,
    Post post,
  ) async {
    final confirmed = await showDeletePostDialog(
      context,
      postTitle: post.title,
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    final deleted = await ref
        .read(deletePostControllerProvider.notifier)
        .deletePost(post.id);
    if (!context.mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    if (deleted) {
      messenger.showSnackBar(const SnackBar(content: Text('Post deleted')));
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.posts);
      }
      return;
    }
    final failure =
        ref.read(deletePostControllerProvider).failure ??
        const UnexpectedFailure();
    messenger.showSnackBar(
      SnackBar(content: Text('Couldn’t delete post. ${failure.userMessage}')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postDetailsControllerProvider(postId));
    final controller = ref.read(postDetailsControllerProvider(postId).notifier);

    ref.listen<PostDetailsState>(postDetailsControllerProvider(postId), (
      previous,
      next,
    ) {
      final refreshFailed =
          (previous?.areCommentsRefreshing ?? false) &&
          !next.areCommentsRefreshing &&
          next.commentsFailure != null &&
          next.comments.isNotEmpty;
      if (refreshFailed) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(next.commentsFailure!.userMessage)),
          );
      }
    });

    final post = state.post;
    final favoritesState = ref.watch(favoritesControllerProvider);
    final isDeleting = ref.watch(
      deletePostControllerProvider.select(
        (deleteState) => deleteState.isDeleting,
      ),
    );

    return AppScaffold(
      title: 'Post',
      actions: [
        // Locally created posts (negative IDs) cannot be bookmarked; favorite
        // storage only accepts server-assigned IDs.
        if (post != null && post.id > 0)
          FavoriteIconButton(
            postTitle: post.title,
            isFavorite: favoritesState.isFavorite(post.id),
            onPressed:
                favoritesState.canToggle &&
                    favoritesState.updatingPostId != post.id
                ? () => ref
                      .read(favoritesControllerProvider.notifier)
                      .toggleFavorite(post.id)
                : null,
          ),
        if (post != null) ...[
          IconButton(
            tooltip: 'Edit post',
            icon: const Icon(Icons.edit_outlined),
            onPressed: isDeleting
                ? null
                : () => context.push(AppRoutes.postEdit(post.id)),
          ),
          if (isDeleting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              tooltip: 'Delete post',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deletePost(context, ref, post),
            ),
        ],
      ],
      body: AdaptiveContent(
        child: _PostDetailsContent(state: state, controller: controller),
      ),
    );
  }
}

class PostUnavailablePage extends StatelessWidget {
  const PostUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Post',
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.article_outlined,
                size: 56,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'This post is no longer available.',
                style: textTheme.titleLarge,
                textAlign: .center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => context.go(AppRoutes.posts),
                child: const Text('Back to posts'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostDetailsContent extends StatelessWidget {
  const _PostDetailsContent({required this.state, required this.controller});

  final PostDetailsState state;
  final PostDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final post = state.post;
    if (post == null) {
      if (state.isPostLoading) {
        return const _PostLoadingView();
      }
      final failure = state.postFailure;
      if (failure != null) {
        return _PostErrorView(
          message: failure is NotFoundFailure
              ? 'This post is no longer available.'
              : failure.userMessage,
          onRetry: controller.retryPost,
        );
      }
      return const _PostLoadingView();
    }

    return RefreshIndicator(
      onRefresh: controller.refreshComments,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.lg,
        ),
        children: [
          _PostContent(post: post),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Comments'),
          const SizedBox(height: AppSpacing.md),
          ..._buildCommentsSection(),
        ],
      ),
    );
  }

  List<Widget> _buildCommentsSection() {
    if (state.areCommentsLoading && state.comments.isEmpty) {
      return const [CommentsLoadingView()];
    }
    final failure = state.commentsFailure;
    if (failure != null && state.comments.isEmpty) {
      return [
        _CommentsErrorView(
          message: failure.userMessage,
          onRetry: controller.retryComments,
        ),
      ];
    }
    if (state.comments.isEmpty) {
      return const [CommentsEmptyView()];
    }
    return [
      for (var index = 0; index < state.comments.length; index++) ...[
        CommentCard(
          key: ValueKey(state.comments[index].id),
          comment: state.comments[index],
        ),
        if (index < state.comments.length - 1)
          const SizedBox(height: AppSpacing.sm),
      ],
    ];
  }
}

class _PostContent extends StatelessWidget {
  const _PostContent({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Author ${post.authorId}',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(post.title, style: textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Text(post.body, style: textTheme.bodyLarge),
      ],
    );
  }
}

class _PostLoadingView extends StatelessWidget {
  const _PostLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: AppSpacing.md),
      children: const [
        SkeletonBar(width: 120, height: 12),
        SizedBox(height: AppSpacing.md),
        SkeletonBar(height: 24),
        SizedBox(height: AppSpacing.sm),
        FractionallySizedBox(widthFactor: 0.7, child: SkeletonBar(height: 24)),
        SizedBox(height: AppSpacing.lg),
        SkeletonBar(height: 14),
        SizedBox(height: AppSpacing.sm),
        SkeletonBar(height: 14),
        SizedBox(height: AppSpacing.sm),
        FractionallySizedBox(widthFactor: 0.5, child: SkeletonBar(height: 14)),
      ],
    );
  }
}

class _PostErrorView extends StatelessWidget {
  const _PostErrorView({required this.message, required this.onRetry});

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
              'Couldn’t load this post',
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

class _CommentsErrorView extends StatelessWidget {
  const _CommentsErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(
              'Couldn’t load comments',
              style: textTheme.titleMedium,
              textAlign: .center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: .center,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
