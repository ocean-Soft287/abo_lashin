import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Back button and the search field.
class SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const SearchHeader({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.onChanged,
    required this.onSubmitted,
  });

  static double get _height => 52.h;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Same pill as the home search bar; navy outline when focused, like the
    // app's input theme.
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      borderSide: BorderSide(color: color, width: width),
    );

    return AnnotatedRegion(
      value: AppTheme.overlayStyle(colors, Theme.of(context).brightness),
      // Same surface and shape as AppTopBar.
      child: Material(
        color: colors.primarySoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppRadius.xl),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Row(
              children: [
                if (Navigator.of(context).canPop()) ...[
                  IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    color: colors.textPrimary,
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: autofocus,
                    textInputAction: TextInputAction.search,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    style: GoogleFonts.alexandria(
                      fontSize: 15.sp,
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'search_product_or_category'.tr(),
                      hintStyle: GoogleFonts.alexandria(
                        fontSize: 14.sp,
                        color: colors.textHint,
                      ),
                      filled: true,
                      fillColor: colors.surface,
                      constraints: BoxConstraints(minHeight: _height),
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colors.primary,
                      ),
                      // Only this button listens to the text.
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller,
                        builder: (context, value, _) {
                          if (value.text.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            tooltip:
                                MaterialLocalizations.of(
                                  context,
                                ).deleteButtonTooltip,
                            icon: const Icon(Icons.close_rounded),
                            color: colors.textSecondary,
                            onPressed: () {
                              controller.clear();
                              onChanged('');
                              focusNode.requestFocus();
                            },
                          );
                        },
                      ),
                      enabledBorder: border(colors.border, 1),
                      focusedBorder: border(colors.primary, 1.4),
                      border: border(colors.border, 1),
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
