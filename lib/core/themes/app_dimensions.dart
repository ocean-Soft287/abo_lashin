import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppDimensions {
  AppDimensions._();

  // Layout cap for large screens; a real width, not a design size.
  static const double maxContentWidth = 1200;

  static double get mobileHorizontalPadding => 16.w;
  static double get tabletHorizontalPadding => 24.w;
  static double get desktopHorizontalPadding => 32.w;

  static double get buttonHeight => 48.h;
  static double get inputHeight => 52.h;

  static double get appBarHeight => 64.h;

  static double get iconSm => 18.r;
  static double get iconMd => 24.r;
  static double get iconLg => 32.r;
  static double get splashLogoMobile => 240.r;
  static double get splashLogoTablet => 280.r;
  static double get splashLogoDesktop => 320.r;
}
