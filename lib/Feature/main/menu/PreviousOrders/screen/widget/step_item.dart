import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constans/app_colors.dart';
class StepItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final String image;
  final bool divider;

  const StepItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.image,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: isActive ? AppColors.mainAppColor : Colors.grey),
            (divider)
                ? Container(
              width: 2,
              height: 30,
              color: isActive ? AppColors.mainAppColor : Colors.grey,
            )
                : const SizedBox(),
          ],
        ),
        const SizedBox(width: 16),
        SvgPicture.asset(image, width: 40, ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.alexandria(
                        fontSize: 14.sp,
                        color: isActive ? AppColors.mainAppColor : Colors.grey,
                        fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.alexandria(
                        fontSize: 12.sp,
                        color: isActive ? Colors.black : Colors.grey,
                        fontWeight: isActive ? FontWeight.w400 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}