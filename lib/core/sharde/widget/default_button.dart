

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';





class DefaultButton extends StatelessWidget {
  final String text;
  final Function function;
  final Color backgroundColor;
  final Color textColor;
  final bool hasIcon;
  final Widget? icon;
  final double heightButton;
  final Border? border;
  final double borderRadius;
  const DefaultButton({
    super.key,
    required this.text,
    required this.function,
    this.backgroundColor = const Color(0xff293798),
    this.textColor = Colors.white,
    this.hasIcon = false,
    this.icon,
    this.heightButton = 45,
    this.border,this.borderRadius = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: border,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: GestureDetector(
        onTap: () => function(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasIcon && icon != null) icon!,
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.alexandria(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


