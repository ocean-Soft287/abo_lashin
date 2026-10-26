enum ConnectionStatus { connected, disconnected, serverUnreachable }

extension ConnectionStatusX on ConnectionStatus {
  bool get isOnline => this == ConnectionStatus.connected;
}
