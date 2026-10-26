import 'package:flutter/widgets.dart';

abstract final class AppScale {
  AppScale._();

  /// The width the UI was designed at.
  static const double designWidth = 360;

  static const double min = 0.85;
  static const double max = 1.0;

  /// Design size for [ScreenUtilInit] that makes `.w`, `.h`, `.r` and `.sp`
  /// all scale by the same factor: down on phones narrower than
  /// [designWidth], never up on larger phones or tablets, which keep the
  /// design size and get their room from the responsive layouts instead.
  static Size designSizeFor(Size screen) {
    if (screen.isEmpty) return const Size(designWidth, 690);
    final factor = (screen.width / designWidth).clamp(min, max);
    return Size(screen.width / factor, screen.height / factor);
  }
}
