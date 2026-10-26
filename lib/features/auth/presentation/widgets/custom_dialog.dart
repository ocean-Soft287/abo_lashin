import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void customDialog({
  required BuildContext context,
  required String title,
  String subTitle = '',
}) {
  BuildContext? dialogContext;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      dialogContext = context;
      return Dialog(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AppAssets.error,
                width: 120.w,
                height: 120.h,
                repeat: false,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: GoogleFonts.alexandria(
                  fontSize: 15.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              if (subTitle.isNotEmpty) ...[
                SizedBox(height: AppSpacing.sm),
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );

  Future.delayed(const Duration(seconds: 4), () {
    final ctx = dialogContext;
    if (ctx != null &&
        ctx.mounted &&
        (ModalRoute.of(ctx)?.isCurrent ?? false)) {
      Navigator.of(ctx).pop();
    }
  });
}
