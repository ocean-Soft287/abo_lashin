import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';

/// Brand banner at the top of Smart Shopping.
class SmartShoppingHero extends StatelessWidget {
  const SmartShoppingHero({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: colors.headerGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'smart_shopping'.tr(),
                        style: GoogleFonts.alexandria(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: colors.brandYellow,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Icon(Icons.auto_awesome_rounded, color: colors.brandYellow),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'smart_shopping_tagline'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 12.sp,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Container(
            width: 84.w,
            height: 84.h,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                AppAssets.logo,
                fit: BoxFit.contain,
                cacheWidth: 256,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
