import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class UsersEmptyView extends StatelessWidget {
  const UsersEmptyView.noUsers({super.key})
    : icon = Icons.people_outlined,
      title = 'No users yet',
      message = 'User profiles will appear here once they are available.',
      onClearSearch = null;

  const UsersEmptyView.noResults({
    super.key,
    required VoidCallback this.onClearSearch,
  }) : icon = Icons.search_off,
       title = 'No matching users',
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
