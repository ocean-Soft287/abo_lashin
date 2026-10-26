import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:abolashin/core/themes/app_colors.dart';

void showLaunchFailedSnackBar(
  BuildContext context, {
  required String message,
  String? copyValue,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      content: Text(message),
      action:
          copyValue == null
              ? null
              : SnackBarAction(
                label: 'copy'.tr(),
                textColor: context.colors.secondary,
                onPressed: () => copyToClipboard(context, copyValue),
              ),
    ),
  );
}

Future<void> copyToClipboard(BuildContext context, String value) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('copied_to_clipboard'.tr()),
      ),
    );
}
