import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'connection_status.dart';

class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  final StreamController<ConnectionStatus> _controller =
      StreamController<ConnectionStatus>.broadcast();

  StreamSubscription<ConnectivityResult>? _subscription;
  Timer? _debounceTimer;
  bool _interfaceUp = true;
  bool _serverReachable = true;
  ConnectionStatus _currentStatus = ConnectionStatus.connected;

  Stream<ConnectionStatus> get stream => _controller.stream;

  ConnectionStatus get currentStatus => _currentStatus;

  bool get isOnline => _currentStatus.isOnline;

  Future<void> start() async {
    if (_subscription != null) return;
    try {
      _interfaceUp =
          await _connectivity.checkConnectivity() != ConnectivityResult.none;
      _currentStatus = _resolve();
      _subscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
      );
    } catch (_) {
      _interfaceUp = true;
    }
  }

  void reportRequestResult({required bool reachedServer}) {
    if (_serverReachable == reachedServer) return;
    _serverReachable = reachedServer;
    _update();
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final up = result != ConnectivityResult.none;
      if (up == _interfaceUp) return;
      _interfaceUp = up;
      if (up) _serverReachable = true;
      _update();
    });
  }

  ConnectionStatus _resolve() {
    if (!_interfaceUp) return ConnectionStatus.disconnected;
    if (!_serverReachable) return ConnectionStatus.serverUnreachable;
    return ConnectionStatus.connected;
  }

  void _update() {
    final status = _resolve();
    if (status == _currentStatus) return;
    _currentStatus = status;
    if (!_controller.isClosed) _controller.add(status);
  }

  void dispose() {
    _debounceTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
  }
}
