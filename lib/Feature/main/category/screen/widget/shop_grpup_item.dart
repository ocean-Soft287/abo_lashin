import 'package:abolashin/core/constans/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class ShopGroupItem extends StatelessWidget {
  final String? title;
  final Function() onTap;
  final bool isSelected;

  const ShopGroupItem({
    super.key,
    this.title,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 8.r),
      child: Material(
        borderRadius: BorderRadius.circular(20.r),
        color: isSelected ? AppColors.mainAppColor : AppColors.backgroundAppColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:isSelected ?AppColors.mainAppColor :const Color(0xff868686) ,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),

            alignment: Alignment.center,
            padding: REdgeInsets.symmetric(horizontal: 19),
            child: Center(
              child: Text(
                '$title',

                style: GoogleFonts.tajawal(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,

                  color: isSelected ? Colors.white : Colors.black,


                ),

                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }



}