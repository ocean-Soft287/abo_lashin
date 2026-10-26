import 'dart:async';

import 'connection_status.dart';
import 'connectivity_overlay_controller.dart';
import 'connectivity_service.dart';

class ConnectivityObserver {
  ConnectivityObserver._();

  static final ConnectivityObserver instance = ConnectivityObserver._();

  StreamSubscription<ConnectionStatus>? _subscription;
  bool _isInitialized = false;

  void init() {
    if (_isInitialized) return;
    _isInitialized = true;

    _subscription = ConnectivityService.instance.stream.listen(
      ConnectivityOverlayController.instance.show,
    );
  }

  void dispose() {
    _subscription?.cancel();
    ConnectivityOverlayController.instance.dispose();
    _isInitialized = false;
  }
}
