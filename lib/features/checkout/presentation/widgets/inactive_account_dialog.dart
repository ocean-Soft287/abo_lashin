import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/helpers/logger.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/constants/app_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InactiveAccountDialog extends StatelessWidget {
  final String ownerPhoneNumber = AppConfig.supportPhone;

  const InactiveAccountDialog({super.key});

  void _makePhoneCall({required String phone}) async {
    final Uri phoneUri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      loggerWarn('Could not launch $phoneUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xxl + 8,
              AppSpacing.xxl,
              AppSpacing.xxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 84.w,
                  height: 84.h,
                  decoration: BoxDecoration(
                    color: context.colors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_off_outlined,
                    color: context.colors.primary,
                    size: 42.r,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  'account_inactive'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'cannot_place_order_contact_service'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _makePhoneCall(phone: ownerPhoneNumber),
                    icon: const Icon(Icons.call_rounded),
                    label: Text('call'.tr()),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.whatsApp,
                    ),
                    onPressed:
                        () => openWhatsApp(
                          phoneNumber: ownerPhoneNumber,
                          message:
                              'يرجى تفعيل الحساب الخاص بى  رقم ${getIt<SessionManager>().customerPhone} ',
                        ),
                    icon: const Icon(Icons.chat_rounded),
                    label: Text('whatsapp'.tr()),
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 6.h,
            end: 6.w,
            child: IconButton(
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close_rounded,
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showInactiveAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const InactiveAccountDialog();
    },
  );
}

void openWhatsApp({
  required String phoneNumber,
  required String message,
}) async {
  final Uri whatsappUri = Uri.parse(
    'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
  );

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    loggerWarn('Could not launch $whatsappUri');
  }
}
