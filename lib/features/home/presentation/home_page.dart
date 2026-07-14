import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Placeholder landing page shown while the real features are being built.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(Icons.auto_awesome, size: 64, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Welcome to ${AppConstants.appName}',
                style: textTheme.headlineSmall,
                textAlign: .center,
              ),
              const SizedBox(height: 8),
              Text(
                'Project setup is complete. Features are on the way.',
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
