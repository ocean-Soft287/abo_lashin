import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

import 'package:abolashin/core/themes/app_colors.dart';

class HomeNewsStrip extends StatelessWidget {
  final String text;

  const HomeNewsStrip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final fontSize = 12.sp;
    final height = MediaQuery.textScalerOf(context).scale(fontSize) * 1.6;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.colors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.campaign_rounded,
            size: 20.r,
            color: context.colors.secondary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: SizedBox(
              height: height,
              child: Marquee(
                text: text,
                textDirection: Directionality.of(context),
                style: GoogleFonts.alexandria(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: context.colors.primary,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 40.w,
                velocity: 50.0,
                pauseAfterRound: const Duration(milliseconds: 500),
                startPadding: 10.w,
                accelerationDuration: const Duration(milliseconds: 500),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
