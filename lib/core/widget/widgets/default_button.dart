import 'package:flutter/material.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function function;
  final Color? backgroundColor;
  final Color? textColor;
  final bool hasIcon;
  final Widget? icon;
  final double heightButton;
  final Border? border;
  final double? borderRadius;
  const DefaultButton({
    super.key,
    required this.text,
    required this.function,
    this.backgroundColor,
    this.textColor,
    this.hasIcon = false,
    this.icon,
    this.heightButton = 50,
    this.border,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = backgroundColor ?? colors.brand;
    final side =
        border?.top ??
        (background == Colors.transparent || background == colors.surface
            ? BorderSide(color: colors.primary.withValues(alpha: 0.4))
            : BorderSide.none);

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.md),
          side: side,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => function(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (heightButton < 44 ? 44 : heightButton).h,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasIcon && icon != null) ...[
                    icon!,
                    SizedBox(width: 10.w),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor ?? colors.onBrand,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
