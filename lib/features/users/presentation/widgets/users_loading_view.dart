import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/skeleton_bar.dart';

class UsersLoadingView extends StatelessWidget {
  const UsersLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: 6,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => const _SkeletonUserCard(),
    );
  }
}

class _SkeletonUserCard extends StatelessWidget {
  const _SkeletonUserCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: .circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SkeletonBar(width: 160, height: 14),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBar(width: 100, height: 10),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBar(height: 12),
                  SizedBox(height: AppSpacing.xs),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: SkeletonBar(height: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
