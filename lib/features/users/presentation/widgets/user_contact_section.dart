import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/user.dart';

class UserContactSection extends StatelessWidget {
  const UserContactSection({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final address = user.address;

    return Column(
      crossAxisAlignment: .start,
      children: [
        const SectionHeader(title: 'Contact'),
        const SizedBox(height: AppSpacing.md),
        _ContactRow(icon: Icons.phone_outlined, text: user.phone),
        const SizedBox(height: AppSpacing.sm),
        _ContactRow(icon: Icons.language_outlined, text: user.website),
        const SizedBox(height: AppSpacing.sm),
        _ContactRow(
          icon: Icons.place_outlined,
          text:
              '${address.street}, ${address.suite}\n'
              '${address.city}, ${address.zipcode}',
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: .start,
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: textTheme.bodyMedium)),
      ],
    );
  }
}
