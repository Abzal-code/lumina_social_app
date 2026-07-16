import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Failure title and message with a retry button.
///
/// The default constructor fills a page-level slot and stays scrollable on
/// short screens; [ErrorStateView.inline] is a card variant for sections
/// embedded in another scrollable, such as the comments block under a post.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  }) : _inline = false;

  const ErrorStateView.inline({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  }) : _inline = true;

  final String title;
  final String message;
  final VoidCallback onRetry;

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
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Text(title, style: textTheme.titleMedium, textAlign: .center),
              const SizedBox(height: AppSpacing.xs),
              message,
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 56, color: colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: textTheme.titleLarge, textAlign: .center),
            const SizedBox(height: AppSpacing.sm),
            message,
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
