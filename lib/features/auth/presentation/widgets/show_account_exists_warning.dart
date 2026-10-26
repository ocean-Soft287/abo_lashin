import 'package:abolashin/core/constants/app_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/auth/presentation/screen/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showAccountExistsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                AppAssets.warning,
                width: 110.w,
                height: 110.h,
                repeat: false,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'account_exists'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.alexandria(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'account_exists_message'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.alexandria(
                  fontSize: 13.sp,
                  height: 1.6,
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () => context.pushScreen(const LoginScreen()),
                icon: const Icon(Icons.login_rounded),
                label: Text('login'.tr()),
              ),
              SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: Text('create_new_account'.tr()),
              ),
            ],
          ),
        ),
      );
    },
  );
}
