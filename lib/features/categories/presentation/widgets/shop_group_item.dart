import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsetsDirectional.only(end: AppSpacing.sm),
      child: Material(
        color: isSelected ? context.colors.primary : context.colors.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? context.colors.primary : context.colors.border,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 44.h, minWidth: 56.w),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Center(
                widthFactor: 1,
                child: Text(
                  '$title',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color:
                        isSelected
                            ? context.colors.onPrimary
                            : context.colors.textPrimary,
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
