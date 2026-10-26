import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/features/auth/presentation/widgets/session_actions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showLogoutConfirmationDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: context.colors.dangerSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.logout_rounded,
            color: context.colors.danger,
            size: 30.r,
          ),
        ),
        title: Text(
          'logout_confirmation'.tr(),
          textAlign: TextAlign.center,
          style: GoogleFonts.alexandria(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        content: Text(
          'logout_confirmation_message'.tr(),
          textAlign: TextAlign.center,
          style: GoogleFonts.alexandria(
            fontSize: 13.sp,
            height: 1.5,
            color: context.colors.textSecondary,
          ),
        ),
        actionsPadding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('cancel'.tr()),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.danger,
                  ),
                  onPressed: () => signOutAndReset(context),
                  child: Text('confirm'.tr()),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
