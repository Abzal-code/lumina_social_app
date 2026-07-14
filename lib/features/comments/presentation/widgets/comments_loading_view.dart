import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/skeleton_bar.dart';

class CommentsLoadingView extends StatelessWidget {
  const CommentsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SkeletonCommentCard(),
        SizedBox(height: AppSpacing.sm),
        _SkeletonCommentCard(),
        SizedBox(height: AppSpacing.sm),
        _SkeletonCommentCard(),
      ],
    );
  }
}

class _SkeletonCommentCard extends StatelessWidget {
  const _SkeletonCommentCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SkeletonBar(width: 140, height: 12),
            SizedBox(height: AppSpacing.sm),
            SkeletonBar(width: 200, height: 10),
            SizedBox(height: AppSpacing.md),
            SkeletonBar(height: 12),
            SizedBox(height: AppSpacing.xs),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: SkeletonBar(height: 12),
            ),
          ],
        ),
      ),
    );
  }
}
