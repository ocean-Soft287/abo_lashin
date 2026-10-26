import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';

/// Suggestion pill: highlighted ones (best sellers, offers) carry a flame,
/// the others an arrow pointing back up into the search field.
class SearchChip extends StatelessWidget {
  final String label;
  final bool highlighted;
  final VoidCallback onTap;

  const SearchChip({
    super.key,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final radius = BorderRadius.circular(AppRadius.pill);

    // Pill chips like the app's chip theme; offers and best sellers use the
    // soft orange the app already uses for offers.
    return Material(
      color: highlighted ? colors.secondarySoft : colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: colors.border),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 48.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexandria(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  highlighted
                      ? Icons.local_fire_department_rounded
                      : (rtl
                          ? Icons.north_west_rounded
                          : Icons.north_east_rounded),
                  size: 20.r,
                  color: highlighted ? colors.secondary : colors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
