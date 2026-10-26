typedef SyncCallback = Future<void> Function();

class SyncManager {
  final List<SyncCallback> _syncCallbacks = [];

  void registerSyncCallback(SyncCallback callback) {
    _syncCallbacks.add(callback);
  }

  void unregisterSyncCallback(SyncCallback callback) {
    _syncCallbacks.remove(callback);
  }

  Future<void> syncAll() async {
    for (final callback in _syncCallbacks) {
      await callback();
    }
  }
}
