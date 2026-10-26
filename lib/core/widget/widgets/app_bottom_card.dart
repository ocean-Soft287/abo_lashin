import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_radius.dart';

class AppBottomCard extends StatelessWidget {
  const AppBottomCard({
    super.key,
    required this.child,
    this.top = 145,
    this.height,
    this.padding,
  });

  final Widget child;
  final double top;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: top.h,
      bottom: 0,
      child: Container(
        height: height?.h,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        child: child,
      ),
    );
  }
}
