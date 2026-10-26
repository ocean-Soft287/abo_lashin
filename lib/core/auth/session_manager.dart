import 'dart:async';

import '../identity/user_identity.dart';
import '../local/app_preferences.dart';
import '../local/hive_service_impl.dart';

enum SessionStatus { authenticated, guest, unauthenticated }

class SessionManager {
  final IUserCache _userCache;
  final ISessionCache _sessionCache;

  final StreamController<SessionStatus> _statusController =
      StreamController<SessionStatus>.broadcast();

  SessionManager({
    required IUserCache userCache,
    required ISessionCache sessionCache,
  }) : _userCache = userCache,
       _sessionCache = sessionCache;

  Stream<SessionStatus> get statusStream => _statusController.stream;

  UserIdentity? get identity =>
      UserIdentity.fromMap(_userCache.getCachedUserModel());

  SessionStatus get currentStatus {
    if (identity != null) return SessionStatus.authenticated;
    if (_sessionCache.isGuestSession) return SessionStatus.guest;
    return SessionStatus.unauthenticated;
  }

  bool get isAuthenticated => currentStatus == SessionStatus.authenticated;

  bool get isGuest => currentStatus == SessionStatus.guest;

  bool get hasSession => currentStatus != SessionStatus.unauthenticated;

  int? get customerId => identity?.customerId;

  String get customerPhone => identity?.phone ?? '';

  String get customerName => identity?.name ?? '';

  Future<void> restore(AppPreferences preferences) async {
    if (identity == null) {
      final legacy = UserIdentity.tryParse(
        customerId: preferences.legacyCustomerId,
        phone: preferences.legacyCustomerPhone,
        name: preferences.legacyCustomerName,
      );
      if (legacy != null) {
        await _userCache.cacheUserModel(legacy.toMap());
        await _sessionCache.saveGuestSession(false);
      }
    }
    await preferences.clearLegacySession();
  }

  Future<void> signIn(UserIdentity user) async {
    await _userCache.cacheUserModel(user.toMap());
    await _sessionCache.saveGuestSession(false);
    _emit(SessionStatus.authenticated);
  }

  Future<void> continueAsGuest() async {
    if (isAuthenticated) return;
    await _sessionCache.saveGuestSession(true);
    _emit(SessionStatus.guest);
  }

  Future<void> updateName(String name) async {
    final current = identity;
    if (current == null) return;
    await _userCache.updateCachedUserModel(
      current.copyWith(name: name).toMap(),
    );
  }

  Future<void> signOut() async {
    await _userCache.clearUserModel();
    await _sessionCache.saveGuestSession(false);
    _emit(SessionStatus.unauthenticated);
  }

  void _emit(SessionStatus status) {
    if (!_statusController.isClosed) _statusController.add(status);
  }

  void dispose() {
    _statusController.close();
  }
}
