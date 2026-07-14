import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 2,
            overflow: .ellipsis,
          ),
        ),
        if (action != null) ...[const SizedBox(width: AppSpacing.sm), action!],
      ],
    );
  }
}
