import 'dart:async';

import 'package:flutter/material.dart';

import 'app_navigator.dart';
import 'connection_status.dart';
import 'connectivity_banner.dart';

class ConnectivityOverlayController {
  ConnectivityOverlayController._();

  static final ConnectivityOverlayController instance =
      ConnectivityOverlayController._();

  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;
  final ValueNotifier<ConnectionStatus> _statusNotifier =
      ValueNotifier<ConnectionStatus>(ConnectionStatus.connected);

  void show(ConnectionStatus status) {
    _hideTimer?.cancel();

    final overlay = AppNavigator.overlay;
    if (overlay == null) return;

    _statusNotifier.value = status;

    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder:
            (_) => Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<ConnectionStatus>(
                valueListenable: _statusNotifier,
                builder: (_, status, __) => ConnectivityBanner(status: status),
              ),
            ),
      );
      overlay.insert(_overlayEntry!);
    }
    if (status == ConnectionStatus.connected) {
      _hideTimer = Timer(const Duration(seconds: 2), hide);
    } else if (status == ConnectionStatus.serverUnreachable) {
      _hideTimer = Timer(const Duration(seconds: 4), hide);
    }
  }

  void hide() {
    _hideTimer?.cancel();

    if (_overlayEntry != null) {
      if (_overlayEntry!.mounted) {
        _overlayEntry!.remove();
      }
      _overlayEntry = null;
    }
  }

  void dispose() {
    _hideTimer?.cancel();
    _statusNotifier.dispose();
    hide();
  }
}
