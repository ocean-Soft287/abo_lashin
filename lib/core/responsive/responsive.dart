import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

abstract final class Responsive {
  Responsive._();

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static bool isMobile(BuildContext context) {
    return AppBreakpoints.isMobile(width(context));
  }

  static bool isSmallTablet(BuildContext context) {
    return AppBreakpoints.isSmallTablet(width(context));
  }

  static bool isMediumOrLarger(BuildContext context) {
    return AppBreakpoints.isMediumOrLarger(width(context));
  }

  static bool isTablet(BuildContext context) {
    return AppBreakpoints.isTablet(width(context));
  }

  static bool isDesktop(BuildContext context) {
    return AppBreakpoints.isDesktop(width(context));
  }

  static bool isMobileOrTablet(BuildContext context) {
    return !isDesktop(context);
  }

  static bool showsThreePanels(BuildContext context) {
    return width(context) >= AppBreakpoints.threePanels;
  }

  static bool isCompactHeight(BuildContext context) {
    return height(context) < AppBreakpoints.compactHeight;
  }
}
