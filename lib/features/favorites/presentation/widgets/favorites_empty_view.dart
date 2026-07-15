import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';

class FavoritesEmptyView extends StatelessWidget {
  const FavoritesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(Icons.bookmark_outline, size: 56, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No favorites yet',
            style: textTheme.titleLarge,
            textAlign: .center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Bookmark posts you want to revisit and they will appear here.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: .center,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => context.go(AppRoutes.posts),
            child: const Text('Browse posts'),
          ),
        ],
      ),
    );
  }
}
