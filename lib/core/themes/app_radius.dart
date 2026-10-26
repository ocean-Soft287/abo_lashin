import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppRadius {
  AppRadius._();

  static double get xs => 4.r;
  static double get sm => 10.r;
  static double get md => 14.r;
  static double get lg => 18.r;
  static double get xl => 24.r;

  // Fully rounded; large enough that scaling would change nothing.
  static const double pill = 100;
  static const double circular = 999;
}
