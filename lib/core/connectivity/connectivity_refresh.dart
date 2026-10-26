import 'dart:async';

import 'package:flutter/widgets.dart';

import 'connection_status.dart';
import 'connectivity_service.dart';

typedef ConnectivityRefreshCallback = FutureOr<void> Function();

class ConnectivityRefresh extends StatefulWidget {
  const ConnectivityRefresh({
    super.key,
    required this.child,
    required this.onReconnect,
  });

  final Widget child;
  final ConnectivityRefreshCallback onReconnect;

  @override
  State<ConnectivityRefresh> createState() => _ConnectivityRefreshState();
}

class _ConnectivityRefreshState extends State<ConnectivityRefresh> {
  StreamSubscription<ConnectionStatus>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = ConnectivityService.instance.stream.listen((status) {
      if (status == ConnectionStatus.connected) {
        widget.onReconnect();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
