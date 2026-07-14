import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class PostsEmptyView extends StatelessWidget {
  const PostsEmptyView.noPosts({super.key})
    : icon = Icons.inbox_outlined,
      title = 'Nothing here yet',
      message = 'New posts will appear here as soon as they are published.',
      onClearSearch = null;

  const PostsEmptyView.noResults({
    super.key,
    required VoidCallback this.onClearSearch,
  }) : icon = Icons.search_off,
       title = 'No matching posts',
       message = 'Try a different search term.';

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 56, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: textTheme.titleLarge, textAlign: .center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: .center,
          ),
          if (onClearSearch != null) ...[
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: onClearSearch,
              child: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }
}
