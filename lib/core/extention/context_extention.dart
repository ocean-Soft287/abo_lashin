import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_radius.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  Orientation get orientation => MediaQuery.orientationOf(this);

  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  String get languageCode => Localizations.localeOf(this).languageCode;

  bool get isArabic => languageCode == 'ar';

  bool get isEnglish => languageCode == 'en';

  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  bool get isLtr => !isRtl;

  FocusScopeNode get focusScopeNode => FocusScope.of(this);

  void showErrorMessage(String message) {
    showSnack(message, isError: true);
  }

  void showSuccessMessage(String message) {
    showSnack(message);
  }

  void showSnack(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;

    final palette = colors;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: isError ? palette.onDanger : palette.onSuccess,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.font(
                    fontSize: 13.sp,
                    color: isError ? palette.onDanger : palette.onSuccess,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isError ? palette.danger : palette.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.all(AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      );
  }

  Future<void> showLoadingDialog({
    String? message,
    bool canPop = false,
    bool barrierDismissible = false,
  }) {
    return showDialog<void>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            content: Row(
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: const CircularProgressIndicator(strokeWidth: 2.5),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(
                    message ?? '',
                    style: AppTextStyles.font(
                      fontSize: 14.sp,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) {
        final palette = context.colors;
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            FilledButton(
              style:
                  destructive
                      ? FilledButton.styleFrom(
                        backgroundColor: palette.danger,
                        foregroundColor: palette.onDanger,
                      )
                      : null,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  void dismissDialog<T extends Object?>({T? result}) {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop<T>(result);
    }
  }
}
