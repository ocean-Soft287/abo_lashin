import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBack;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.page,
          topInset + AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        decoration: BoxDecoration(
          color: context.colors.primarySoft,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 44.h,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child:
                    showBack && Navigator.of(context).canPop()
                        ? IconButton(
                          tooltip:
                              MaterialLocalizations.of(
                                context,
                              ).backButtonTooltip,
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: context.colors.textPrimary,
                          onPressed: () => Navigator.maybePop(context),
                        )
                        : null,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26.r),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26.r),
                child:
                Image.asset(AppAssets.logo, width: 96.w, height: 96.h),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.alexandria(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: context.colors.primary,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 6.h),
              Text(
                subtitle!,
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
  }
}

class AuthSectionLabel extends StatelessWidget {
  final String text;
  final IconData icon;

  const AuthSectionLabel({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: context.colors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18.r, color: context.colors.primary),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.alexandria(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
