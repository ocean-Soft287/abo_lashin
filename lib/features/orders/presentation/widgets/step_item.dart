import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final String image;
  final bool divider;

  const StepItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.image,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? context.colors.primary : context.colors.textHint;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28.w,
            child: Column(
              children: [
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: isActive ? color : context.colors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child:
                      isActive
                          ? Icon(
                            Icons.check_rounded,
                            size: 15.r,
                            color: context.colors.onPrimary,
                          )
                          : null,
                ),
                if (divider)
                  Expanded(
                    child: Container(
                      width: 2.w,
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      color: isActive ? color : context.colors.border,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Opacity(
            opacity: isActive ? 1 : 0.45,
            child: SvgPicture.asset(image, width: 36.w, height: 36.h),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: divider ? AppSpacing.lg : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      color:
                          isActive
                              ? context.colors.textPrimary
                              : context.colors.textHint,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.alexandria(
                      fontSize: 11.5.sp,
                      height: 1.4,
                      color:
                          isActive
                              ? context.colors.textSecondary
                              : context.colors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
