import 'package:abolashin/core/constans/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class EmptyOrdersWidget extends StatelessWidget {
  final String message;
  final String actionText;

  const EmptyOrdersWidget({
    super.key,
    required this.message,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AppAssets.cartEmpty, width: 300),
          SizedBox(height: 10.h),
          Text(
            message,
            style: GoogleFonts.alexandria(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            actionText,
            style: GoogleFonts.alexandria(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}