import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _highlights = [
    (
      icon: Icons.article_outlined,
      title: 'Discover posts',
      description: 'Browse and search stories from the whole community.',
    ),
    (
      icon: Icons.people_outlined,
      title: 'Explore authors',
      description: 'Get to know the people behind every post.',
    ),
    (
      icon: Icons.favorite_outline,
      title: 'Save favorites',
      description: 'Keep the posts you love one tap away.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: AppConstants.appName,
      body: SingleChildScrollView(
        child: AdaptiveContent(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('Welcome to Lumina', style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'A calm place to read, explore, and collect the posts '
                'that matter to you.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'What you can do'),
              const SizedBox(height: AppSpacing.md),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 560;
                  if (!isWide) {
                    return Column(
                      children: [
                        for (final highlight in _highlights) ...[
                          _HighlightCard(highlight: highlight),
                          if (highlight != _highlights.last)
                            const SizedBox(height: AppSpacing.sm),
                        ],
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: .start,
                    children: [
                      for (final highlight in _highlights) ...[
                        Expanded(child: _HighlightCard(highlight: highlight)),
                        if (highlight != _highlights.last)
                          const SizedBox(width: AppSpacing.sm),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Align(
                alignment: .center,
                child: FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.posts),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Browse posts'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.highlight});

  final ({IconData icon, String title, String description}) highlight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Icon(highlight.icon, color: colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(highlight.title, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              highlight.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
