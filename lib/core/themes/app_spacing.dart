import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppSpacing {
  AppSpacing._();

  static double get xs => 2.w;
  static double get sm => 4.w;
  static double get md => 8.w;
  static double get lg => 12.w;
  static double get xl => 16.w;
  static double get xxl => 20.w;
  static double get xxxl => 28.w;
  static double get huge => 44.w;
  static double get page => 12.w;
}
