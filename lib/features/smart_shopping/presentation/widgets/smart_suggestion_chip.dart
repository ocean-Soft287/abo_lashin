import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';

/// White pill from the reference's "Try:" row. The loading variant is not
/// tappable and says what is still being fetched.
class SmartSuggestionChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool loading;

  const SmartSuggestionChip({
    super.key,
    required this.label,
    required VoidCallback this.onTap,
    this.icon,
  }) : loading = false;

  const SmartSuggestionChip.loading({super.key, required this.label})
    : icon = null,
      onTap = null,
      loading = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = StadiumBorder(side: BorderSide(color: colors.border));
    return Material(
      color: colors.surface,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading)
                  SizedBox.square(
                    dimension: 16.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.textHint,
                    ),
                  )
                else if (icon != null)
                  Icon(icon, size: 18.r, color: colors.primary),
                if (loading || icon != null) SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: loading ? colors.textHint : colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
