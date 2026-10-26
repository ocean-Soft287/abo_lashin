import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/constants/app_config.dart';

import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/widget/widgets/launch_feedback.dart';

import '../../../../core/servise_locator/app_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  static const Color _whatsAppGreen = AppColors.whatsApp;

  static String displayPhone(String phone) => '+$phone';

  Future<void> _openWhatsApp(BuildContext context) async {
    try {
      await AppLauncher.openWhatsApp(
        phone: AppConfig.supportWhatsApp,
        message: 'support_whatsapp_message'.tr(),
      );
    } catch (_) {
      if (!context.mounted) return;

      showLaunchFailedSnackBar(
        context,
        message: 'whatsapp_open_failed'.tr(),
        copyValue: displayPhone(AppConfig.supportWhatsApp),
      );
    }
  }

  Future<void> _openDialer(BuildContext context) async {
    try {
      await AppLauncher.makePhoneCall(AppConfig.supportPhone);
    } catch (_) {
      if (!context.mounted) return;

      showLaunchFailedSnackBar(
        context,
        message: 'dialer_open_failed'.tr(),
        copyValue: displayPhone(AppConfig.supportPhone),
      );
    }
  }

  Future<void> _openEmail(BuildContext context, String address) async {
    try {
      await AppLauncher.sendEmail(
        email: address,
        subject: 'support_email_subject'.tr(),
      );
    } catch (_) {
      if (!context.mounted) return;

      showLaunchFailedSnackBar(
        context,
        message: 'email_open_failed'.tr(),
        copyValue: address,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const email = AppConfig.supportEmail;

    return Scaffold(
      backgroundColor: context.colors.scaffold,
      appBar: AppTopBar(title: 'customer_support'.tr()),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.page),
        children: [
          const _SupportHeader(),
          SizedBox(height: AppSpacing.xl),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppSpacing.xs,
              bottom: AppSpacing.sm,
            ),
            child: AppSectionTitle(title: 'contact_methods'.tr()),
          ),
          ContactMethodCard(
            icon: Icons.chat_rounded,
            color: _whatsAppGreen,
            title: 'whatsapp'.tr(),
            subtitle: 'whatsapp_support_hint'.tr(),
            onTap: () => _openWhatsApp(context),
          ),
          SizedBox(height: AppSpacing.md),
          ContactMethodCard(
            icon: Icons.call_rounded,
            color: context.colors.primary,
            title: 'call_us'.tr(),
            subtitle: 'call_support_hint'.tr(),
            onTap: () => _openDialer(context),
          ),
          // const SizedBox(height: AppSpacing.md),
          // ContactMethodCard(
          //   icon: Icons.mail_outline_rounded,
          //   color: context.colors.secondary,
          //   title: 'email'.tr(),
          //   subtitle: email == null
          //       ? 'not_available_currently'.tr()
          //       : 'email_support_hint'.tr(),
          //   onTap: email == null
          //       ? null
          //       : () => _openEmail(context, email),
          // ),
        ],
      ),
    );
  }
}

class _SupportHeader extends StatelessWidget {
  const _SupportHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: context.colors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 30.r,
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'support_welcome_title'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'support_welcome_message'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 12.sp,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactMethodCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ContactMethodCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final tint = enabled ? color : context.colors.textHint;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: tint),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.alexandria(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        enabled
                            ? context.colors.textPrimary
                            : context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alexandria(
                    fontSize: 12.sp,
                    height: 1.5,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (enabled)
            Icon(Icons.chevron_right_rounded, color: context.colors.textHint),
        ],
      ),
    );
  }
}
