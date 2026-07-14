import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Favorites',
      body: AdaptiveContent(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.favorite_outline,
                size: 56,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your reading list lives here',
                style: textTheme.titleLarge,
                textAlign: .center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Save posts you love and find them again in one tap.',
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
