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
import '../../posts/presentation/widgets/post_card.dart';
import '../application/user_profile_controller.dart';
import '../application/user_profile_state.dart';
import 'widgets/user_company_section.dart';
import 'widgets/user_contact_section.dart';
import 'widgets/user_profile_header.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProfileControllerProvider(userId));
    final controller = ref.read(userProfileControllerProvider(userId).notifier);

    ref.listen<UserProfileState>(userProfileControllerProvider(userId), (
      previous,
      next,
    ) {
      final refreshFailed =
          (previous?.arePostsRefreshing ?? false) &&
          !next.arePostsRefreshing &&
          next.postsFailure != null &&
          next.posts.isNotEmpty;
      if (refreshFailed) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(next.postsFailure!.userMessage)),
          );
      }
    });

    return AppScaffold(
      title: 'Profile',
      body: AdaptiveContent(
        child: _UserProfileContent(state: state, controller: controller),
      ),
    );
  }
}

class UserUnavailablePage extends StatelessWidget {
  const UserUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Profile',
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.person_off_outlined,
                size: 56,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'This profile is not available.',
                style: textTheme.titleLarge,
                textAlign: .center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => context.go(AppRoutes.users),
                child: const Text('Back to users'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfileContent extends StatelessWidget {
  const _UserProfileContent({required this.state, required this.controller});

  final UserProfileState state;
  final UserProfileController controller;

  @override
  Widget build(BuildContext context) {
    final user = state.user;
    if (user == null) {
      if (state.isUserLoading) {
        return const _ProfileLoadingView();
      }
      final failure = state.userFailure;
      if (failure != null) {
        return _ProfileErrorView(
          message: failure is NotFoundFailure
              ? 'This profile is not available.'
              : failure.userMessage,
          onRetry: controller.retryUser,
        );
      }
      return const _ProfileLoadingView();
    }

    return RefreshIndicator(
      onRefresh: controller.refreshPosts,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.lg,
        ),
        children: [
          UserProfileHeader(user: user),
          const SizedBox(height: AppSpacing.xl),
          UserContactSection(user: user),
          const SizedBox(height: AppSpacing.xl),
          UserCompanySection(company: user.company),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Publications'),
          const SizedBox(height: AppSpacing.md),
          ..._buildPublicationsSection(),
        ],
      ),
    );
  }

  List<Widget> _buildPublicationsSection() {
    if (state.arePostsLoading && state.posts.isEmpty) {
      return const [_PublicationsLoadingView()];
    }
    final failure = state.postsFailure;
    if (failure != null && state.posts.isEmpty) {
      return [
        _PublicationsErrorView(
          message: failure.userMessage,
          onRetry: controller.retryPosts,
        ),
      ];
    }
    if (state.posts.isEmpty) {
      return const [_PublicationsEmptyView()];
    }
    return [
      for (var index = 0; index < state.posts.length; index++) ...[
        PostCard(
          key: ValueKey(state.posts[index].id),
          post: state.posts[index],
        ),
        if (index < state.posts.length - 1)
          const SizedBox(height: AppSpacing.sm),
      ],
    ];
  }
}

class _ProfileLoadingView extends StatelessWidget {
  const _ProfileLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: AppSpacing.md),
      children: [
        Row(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: .circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SkeletonBar(height: 24),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBar(width: 120, height: 12),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBar(width: 180, height: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        const SkeletonBar(width: 140, height: 20),
        const SizedBox(height: AppSpacing.md),
        const SkeletonBar(height: 14),
        const SizedBox(height: AppSpacing.sm),
        const SkeletonBar(height: 14),
        const SizedBox(height: AppSpacing.sm),
        const FractionallySizedBox(
          widthFactor: 0.7,
          child: SkeletonBar(height: 14),
        ),
      ],
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({required this.message, required this.onRetry});

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
              'Couldn’t load this profile',
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

class _PublicationsLoadingView extends StatelessWidget {
  const _PublicationsLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SkeletonPublicationCard(),
        SizedBox(height: AppSpacing.sm),
        _SkeletonPublicationCard(),
      ],
    );
  }
}

class _SkeletonPublicationCard extends StatelessWidget {
  const _SkeletonPublicationCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SkeletonBar(height: 16),
            SizedBox(height: AppSpacing.sm),
            SkeletonBar(height: 12),
            SizedBox(height: AppSpacing.xs),
            FractionallySizedBox(
              widthFactor: 0.6,
              child: SkeletonBar(height: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _PublicationsErrorView extends StatelessWidget {
  const _PublicationsErrorView({required this.message, required this.onRetry});

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
              'Couldn’t load publications',
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

class _PublicationsEmptyView extends StatelessWidget {
  const _PublicationsEmptyView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Icon(Icons.article_outlined, size: 40, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.sm),
          Text('No publications yet', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'This user has not published anything.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
