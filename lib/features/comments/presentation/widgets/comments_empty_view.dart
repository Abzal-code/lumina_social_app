import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class CommentsEmptyView extends StatelessWidget {
  const CommentsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Icon(Icons.chat_bubble_outline, size: 40, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.sm),
          Text('No comments yet', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'This post has not received any comments.',
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
