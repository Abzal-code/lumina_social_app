import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/user.dart';
import 'user_initials_avatar.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: .start,
      children: [
        UserInitialsAvatar(name: user.name, radius: 32),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(user.name, style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '@${user.username}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                user.email,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
