import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/constants/app_config.dart';
import 'package:abolashin/core/widget/widgets/launch_feedback.dart';
import 'package:abolashin/core/services/external_links.dart';
import 'package:abolashin/core/services/app_update/app_update_policy.dart';
import 'package:abolashin/core/services/app_update/app_update_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> _openStore(BuildContext context) async {
  final opened = await ExternalLinks.openStoreListing();
  if (!opened && context.mounted) {
    showLaunchFailedSnackBar(
      context,
      message: 'store_open_failed'.tr(),
      copyValue: AppConfig.playStoreUrl,
    );
  }
}

void showPendingOptionalUpdate(BuildContext context) {
  final pending = AppUpdateService.takePendingOptional();
  if (pending == null) return;
  showDialog<void>(
    context: context,
    builder:
        (dialogContext) => Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: AppUpdateCard(
            result: pending,
            onUpdate: () => _openStore(dialogContext),
            onLater: () {
              AppUpdateService.snooze(pending);
              Navigator.of(dialogContext).pop();
            },
          ),
        ),
  );
}

class ForceUpdateScreen extends StatelessWidget {
  final AppUpdateCheck result;

  const ForceUpdateScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.colors.primary,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: Material(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: Builder(
                  builder:
                      (context) => AppUpdateCard(
                        result: result,
                        onUpdate: () => _openStore(context),
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppUpdateCard extends StatelessWidget {
  final AppUpdateCheck result;
  final VoidCallback onUpdate;
  final VoidCallback? onLater;

  const AppUpdateCard({
    super.key,
    required this.result,
    required this.onUpdate,
    this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    final mandatory = onLater == null;
    final version = result.latestVersionName;
    final notes = result.releaseNotes;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 84.w,
                height: 84.h,
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: context.colors.brandYellow,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
                ),
              ),
              PositionedDirectional(
                bottom: -4.h,
                end: -4.w,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.surface, width: 3),
                  ),
                  child: Icon(
                    Icons.system_update_rounded,
                    size: 18.r,
                    color: context.colors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'update_available_title'.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.alexandria(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          if (version != null) ...[
            SizedBox(height: AppSpacing.sm),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: context.colors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                'update_version'.tr(args: [version]),
                style: GoogleFonts.alexandria(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary,
                ),
              ),
            ),
          ],
          SizedBox(height: AppSpacing.md),
          Text(
            mandatory
                ? 'update_required_message'.tr()
                : 'update_optional_message'.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.alexandria(
              fontSize: 13.sp,
              height: 1.6,
              color: context.colors.textSecondary,
            ),
          ),
          if (notes != null) ...[
            SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 160.h),
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'whats_new'.tr(),
                      style: GoogleFonts.alexandria(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      notes,
                      style: GoogleFonts.alexandria(
                        fontSize: 12.sp,
                        height: 1.6,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onUpdate,
              icon: const Icon(Icons.shop_rounded),
              label: Text('update_now'.tr()),
            ),
          ),
          if (!mandatory) ...[
            SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: TextButton(onPressed: onLater, child: Text('later'.tr())),
            ),
          ],
        ],
      ),
    );
  }
}
