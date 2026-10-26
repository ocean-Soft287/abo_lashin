import 'package:flutter/widgets.dart';

abstract final class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 500;
  static const double mediumTablet = 840;
  static const double tablet = 900;
  static const double desktop = 1200;

  static const double threePanels = 1000;

  static const double compactHeight = 560;

  static bool isMobile(double width) {
    return width < mobile;
  }

  static bool isSmallTablet(double width) {
    return width >= mobile && width < mediumTablet;
  }

  static bool isMediumOrLarger(double width) {
    return width >= mediumTablet;
  }

  static bool isTablet(double width) {
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(double width) {
    return width >= desktop;
  }

  static Size designSizeFor(Size size) {
    final width = size.width <= 0 ? 1.0 : size.width;
    final height = size.height <= 0 ? 1.0 : size.height;
    final shortest = size.shortestSide;
    final landscape = width > height;

    if (shortest >= 1024) {
      return landscape ? const Size(1366, 1024) : const Size(1024, 1366);
    }
    if (shortest >= 768) {
      return landscape ? const Size(1024, 768) : const Size(768, 1024);
    }

    final scale =
        shortest < mobile ? (shortest / 390).clamp(0.9, 1.0).toDouble() : 1.0;
    return Size(width / scale, height / scale);
  }
}
