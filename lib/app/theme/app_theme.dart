import 'package:flutter/material.dart';

/// Central place for the application theme.
///
/// Only a minimal Material 3 light theme for now; the complete design
/// system arrives in Phase 1B.
abstract final class AppTheme {
  static ThemeData get light =>
      ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo));
}
