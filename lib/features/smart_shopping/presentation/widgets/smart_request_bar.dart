import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/smart_shopping/presentation/widgets/smart_shopping_actions.dart';

/// "Type your request" bar; the request runs the catalog product search.
class SmartRequestBar extends StatefulWidget {
  const SmartRequestBar({super.key});

  @override
  State<SmartRequestBar> createState() => _SmartRequestBarState();
}

class _SmartRequestBarState extends State<SmartRequestBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    SmartShoppingActions.search(context, text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _send(),
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'smart_request_hint'.tr(),
                    hintStyle: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      color: colors.textHint,
                    ),
                    filled: true,
                    fillColor: colors.surfaceMuted,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: 16.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              // Rebuilds only the button as the text changes.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, _) {
                  final enabled = value.text.trim().isNotEmpty;
                  return SizedBox.square(
                    dimension: 56.r,
                    child: IconButton.filled(
                      tooltip: 'search'.tr(),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        disabledBackgroundColor: colors.border,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: enabled ? _send : null,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
