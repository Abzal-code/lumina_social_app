import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/company.dart';

class UserCompanySection extends StatelessWidget {
  const UserCompanySection({super.key, required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        const SectionHeader(title: 'Company'),
        const SizedBox(height: AppSpacing.md),
        Text(company.name, style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          company.catchPhrase,
          style: textTheme.bodyMedium?.copyWith(fontStyle: .italic),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          company.businessSummary,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
