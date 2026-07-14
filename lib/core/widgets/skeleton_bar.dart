import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';

class SkeletonBar extends StatelessWidget {
  const SkeletonBar({super.key, this.width, required this.height});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.smAll,
      ),
    );
  }
}
