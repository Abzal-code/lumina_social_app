import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Posts',
      body: AdaptiveContent(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.article_outlined,
                size: 56,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Stories are on their way',
                style: textTheme.titleLarge,
                textAlign: .center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Soon you will be able to browse and search posts '
                'from the whole community.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: .center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
