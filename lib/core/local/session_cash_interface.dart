part of 'hive_service_impl.dart';

abstract interface class ISessionCache {
  bool get isGuestSession;

  Future<void> saveGuestSession(bool isGuest);
}
