import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../route/routing.dart';
import '../servise_locator/services_locator.dart';
import 'session_manager.dart';

extension AuthGuard on BuildContext {
  bool get isSignedIn => getIt<SessionManager>().isAuthenticated;

  Future<bool> ensureSignedIn() async {
    if (isSignedIn) return true;
    final goToLogin = await showDialog<bool>(
      context: this,
      builder:
          (dialogContext) => AlertDialog(
            icon: const Icon(Icons.lock_outline_rounded),
            title: Text('login_required_title'.tr()),
            content: Text('login_required_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text('not_now'.tr()),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text('login_now'.tr()),
              ),
            ],
          ),
    );
    if (goToLogin == true && mounted) {
      await Navigator.of(this).pushNamed(AppRoute.login);
    }
    return false;
  }
}
