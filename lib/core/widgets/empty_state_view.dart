import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Icon, title, and message for lists and sections without content.
///
/// The default constructor fills a page-level slot; [EmptyStateView.inline]
/// is a compact variant for sections embedded in another scrollable, such as
/// the comments block under a post.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  }) : _inline = false;

  const EmptyStateView.inline({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  }) : action = null,
       _inline = true;

  final IconData icon;
  final String title;
  final String message;

  /// Optional call to action, e.g. a clear-search or browse button.
  final Widget? action;

  final bool _inline;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final message = Text(
      this.message,
      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      textAlign: .center,
    );

    if (_inline) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          children: [
            Icon(icon, size: 40, color: colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            message,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 56, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: textTheme.titleLarge, textAlign: .center),
          const SizedBox(height: AppSpacing.sm),
          message,
          if (action case final action?) ...[
            const SizedBox(height: AppSpacing.lg),
            action,
          ],
        ],
      ),
    );
  }
}
