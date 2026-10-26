import 'package:flutter/material.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final Widget? prefix;
  final Widget? subfix;
  final dynamic obscureText;
  final FormFieldValidator<String>? validator;
  final Color? fillColor;
  final Color? borderColor;
  final double paddingN;
  final bool isReadOnly;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.textInputType = TextInputType.text,
    this.hintText,
    this.prefix,
    this.validator,
    this.subfix,
    this.obscureText,
    this.fillColor,
    this.borderColor,
    this.paddingN = 8,
    this.isReadOnly = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = widget.fillColor ?? colors.surfaceMuted;
    final outlined = fill == colors.surface;
    final focus = widget.borderColor ?? colors.primary;
    final radius = BorderRadius.circular(AppRadius.md);
    final restingSide =
        outlined ? BorderSide(color: colors.border) : BorderSide.none;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.paddingN.h),
      child: TextFormField(
        controller: widget.controller,
        style: AppTextStyles.font(fontSize: 14.sp, color: colors.textPrimary),
        decoration: InputDecoration(
          suffixIcon: widget.subfix,
          prefixIcon: widget.prefix,
          hintText: widget.hintText,
          filled: true,
          fillColor: fill,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 16.w,
          ),
          border: OutlineInputBorder(
            borderRadius: radius,
            borderSide: restingSide,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: restingSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: focus, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: colors.danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: colors.danger, width: 1.4),
          ),
        ),
        keyboardType: widget.textInputType,
        validator: widget.validator,
        obscureText: widget.obscureText ?? false,
        readOnly: widget.isReadOnly,
      ),
    );
  }
}
