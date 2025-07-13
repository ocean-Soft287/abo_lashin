import 'package:abolashin/core/constans/app_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/constans/app_colors.dart';
import '../../../../../core/sharde/widget/default_button.dart';
import '../../../../../core/sharde/widget/navigation.dart';
import '../../../login/screen/login_screen.dart';

void showAccountExistsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AppAssets.warning,
                width: 120,
                height: 120,
                repeat: false,
              ),
              const SizedBox(height: 10),
              Text(
                'account_exists'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mainAppColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
               'account_exists_message'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.alexandria(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.hitColor),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                text: 'login'.tr(),
                function: () {
                  navigato(context, const LoginScreen());

                },
                backgroundColor: AppColors.mainAppColor,
                textColor: Colors.white,
                hasIcon: true,
                icon: const Icon(Icons.login, color: Colors.white),
              ),
              const SizedBox(height: 10),
              DefaultButton(
                text: 'create_new_account'.tr(),
                function: () {
                  Navigator.pop(context);

                },

                backgroundColor: AppColors.secondAppColor,
                textColor: Colors.white,
                hasIcon: true,
                icon: const Icon(Icons.person_add, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    },
  );
}
