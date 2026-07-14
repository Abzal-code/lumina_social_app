import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/adaptive_content.dart';
import '../../../core/widgets/app_scaffold.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Users',
      body: AdaptiveContent(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(Icons.people_outlined, size: 56, color: colorScheme.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Meet the authors',
                style: textTheme.titleLarge,
                textAlign: .center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Profiles of everyone writing on Lumina will appear here.',
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
