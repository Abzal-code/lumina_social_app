import 'package:flutter/material.dart';

/// Circular avatar showing the initials of the first two words of [name].
class UserInitialsAvatar extends StatelessWidget {
  const UserInitialsAvatar({super.key, required this.name, this.radius = 20});

  final String name;
  final double radius;

  String get _initials {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2);
    if (words.isEmpty) {
      return '?';
    }
    return words.map((word) => word[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        _initials,
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
