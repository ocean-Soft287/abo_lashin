import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/constants/app_config.dart';
import 'package:abolashin/core/services/app_review_service.dart';
import 'package:abolashin/core/services/external_links.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/widget/widgets/launch_feedback.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/menu/presentation/screen/privacy_policy_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/about_us_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutAppScreen extends StatelessWidget {
  final Future<PackageInfo> Function() packageInfo;

  const AboutAppScreen({
    super.key,
    this.packageInfo = PackageInfo.fromPlatform,
  });

  Future<void> _rate(BuildContext context) async {
    final opened = await AppReviewService.openStoreListing();
    if (!opened && context.mounted) {
      showLaunchFailedSnackBar(
        context,
        message: 'store_open_failed'.tr(),
        copyValue: AppConfig.playStoreUrl,
      );
    }
  }

  Future<void> _share() async {
    try {
      await Share.share(
        '${'share_app_message'.tr()}\n${AppConfig.playStoreUrl}',
      );
    } catch (_) {}
  }

  Future<void> _openTerms(BuildContext context, String url) async {
    final opened = await ExternalLinks.openUrl(url);
    if (!opened && context.mounted) {
      showLaunchFailedSnackBar(
        context,
        message: 'link_open_failed'.tr(),
        copyValue: url,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const terms = AppConfig.termsOfUseUrl;
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      appBar: AppTopBar(title: 'about_app'.tr()),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.page),
        children: [
          _AppIdentityCard(packageInfo: packageInfo),
          SizedBox(height: AppSpacing.lg),
          AppCard(
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Column(
              children: [
                AppMenuTile(
                  icon: Icons.star_rate_rounded,
                  color: context.colors.secondary,
                  title: 'rate_app'.tr(),
                  subtitle: 'rate_app_hint'.tr(),
                  onTap: () => _rate(context),
                ),
                const _TileDivider(),
                AppMenuTile(
                  icon: Icons.share_rounded,
                  title: 'share_app'.tr(),
                  onTap: _share,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          AppCard(
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Column(
              children: [
                AppMenuTile(
                  icon: Icons.info_outline_rounded,
                  title: 'about_us'.tr(),
                  onTap: () => context.pushScreen(const AboutUsScreen()),
                ),
                const _TileDivider(),
                AppMenuTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'privacy_policy'.tr(),
                  onTap: () => context.pushScreen(const PrivacyPolicyScreen()),
                ),
                // const _TileDivider(),
                // AppMenuTile(
                //   icon: Icons.gavel_rounded,
                //   title: 'terms_of_use'.tr(),
                //   subtitle:
                //       terms == null ? 'not_available_currently'.tr() : null,
                //   color: terms == null ? context.colors.textHint : null,
                //   trailing: terms == null ? const SizedBox.shrink() : null,
                //   onTap:
                //       terms == null ? null : () => _openTerms(context, terms),
                // ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          const DeveloperCompanyCard(),
        ],
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 64.w, end: AppSpacing.md),
      child: const Divider(),
    );
  }
}

class _AppIdentityCard extends StatefulWidget {
  final Future<PackageInfo> Function() packageInfo;

  const _AppIdentityCard({required this.packageInfo});

  @override
  State<_AppIdentityCard> createState() => _AppIdentityCardState();
}

class _AppIdentityCardState extends State<_AppIdentityCard> {
  late final Future<PackageInfo> _info = widget.packageInfo();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        children: [
          Container(
            width: 88.w,
            height: 88.h,
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: context.colors.brandYellow,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'app_display_name'.tr(),
            style: GoogleFonts.alexandria(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          FutureBuilder<PackageInfo>(
            future: _info,
            builder: (context, snapshot) {
              final info = snapshot.data;
              final String label;
              if (info != null) {
                label = 'app_version_build'.tr(
                  args: [info.version, info.buildNumber],
                );
              } else if (snapshot.hasError) {
                label = 'version_unavailable'.tr();
              } else {
                label = '…';
              }
              return InfoChip(
                icon: Icons.verified_outlined,
                label: label,
                background: context.colors.primarySoft,
                foreground: context.colors.primary,
              );
            },
          ),
        ],
      ),
    );
  }
}

class DeveloperCompanyCard extends StatelessWidget {
  const DeveloperCompanyCard({super.key});

  Future<void> _openWebsite(BuildContext context, String url) async {
    final opened = await ExternalLinks.openUrl(url);

    if (!opened && context.mounted) {
      showLaunchFailedSnackBar(
        context,
        message: 'link_open_failed'.tr(),
        copyValue: url,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const website = AppConfig.developerWebsite;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              gradient: colors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Image.asset(
              AppAssets.theOneLogo,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.business_rounded,
                  color: colors.surface,
                  size: 27.r,
                );
              },
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'developed_by'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    AppConfig.developerCompanyName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexandria(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'visit_website'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 10.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Material(
            color: colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: IconButton(
              tooltip: 'visit_website'.tr(),
              onPressed: () => _openWebsite(context, website),
              icon: Icon(
                Icons.open_in_new_rounded,
                color: colors.primary,
                size: 21.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
