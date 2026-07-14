import 'package:flutter/widgets.dart';

abstract final class AppRadius {
  /// Chips and inputs.
  static const double sm = 8;

  /// Cards and buttons.
  static const double md = 12;

  /// Sheets and dialogs.
  static const double lg = 20;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
}
