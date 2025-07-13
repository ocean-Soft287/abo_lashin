import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/constans/app_assets.dart';
import '../../../../../core/constans/app_colors.dart';
void customDialog({
  required BuildContext context,
  required String title,
  String subTitle=''
}) {
  showDialog(
    barrierDismissible: false,
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
                AppAssets.error,
                width: 150,
                height: 150,
                repeat: false,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: GoogleFonts.alexandria(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mainAppColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.alexandria(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.hitColor),
              ),
            ],
          ),
        ),
      );
    },
  );


  Future.delayed(const Duration(seconds: 4), () {
    Navigator.of(context).pop();
  });
}