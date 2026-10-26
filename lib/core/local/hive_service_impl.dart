import 'package:hive_flutter/hive_flutter.dart';

part 'user_cash_interface.dart';
part 'session_cash_interface.dart';
part 'list_cash_interface.dart';

class HiveServiceImpl implements IUserCache, ISessionCache, IListCache {
  static const String userBoxName = 'user_box';
  static const String sessionBoxName = 'session_box';

  static const String currentUserKey = 'current_user';
  static const String guestSessionKey = 'guest_session';

  static Box<dynamic>? _userBox;
  static Box<dynamic>? _sessionBox;

  HiveServiceImpl._();

  static final HiveServiceImpl instance = HiveServiceImpl._();

  static Future<void> init({String? path}) async {
    if (path == null) {
      await Hive.initFlutter();
    } else {
      Hive.init(path);
    }

    _userBox = await Hive.openBox<dynamic>(userBoxName);
    _sessionBox = await Hive.openBox<dynamic>(sessionBoxName);
  }

  @override
  Future<void> cacheUserModel(dynamic user) async {
    await _requireBox(_userBox).put(currentUserKey, user);
  }

  @override
  dynamic getCachedUserModel() {
    return _userBox?.get(currentUserKey);
  }

  @override
  Future<void> updateCachedUserModel(dynamic user) async {
    await _requireBox(_userBox).put(currentUserKey, user);
  }

  @override
  Future<void> clearUserModel() async {
    await _userBox?.delete(currentUserKey);
  }

  @override
  bool get isGuestSession => _sessionBox?.get(guestSessionKey) == true;

  @override
  Future<void> saveGuestSession(bool isGuest) async {
    await _requireBox(_sessionBox).put(guestSessionKey, isGuest);
  }

  @override
  Future<List<dynamic>?> readList(String boxName, String key) async {
    final box = await Hive.openBox<dynamic>(boxName);
    final value = box.get(key);
    return value is List ? List<dynamic>.from(value) : null;
  }

  @override
  Future<void> saveList(String boxName, String key, List<dynamic> list) async {
    final box = await Hive.openBox<dynamic>(boxName);
    await box.put(key, list);
  }

  @override
  Future<void> deleteList(String boxName, String key) async {
    final box = await Hive.openBox<dynamic>(boxName);
    await box.delete(key);
  }

  Future<void> clearSession() async {
    await Future.wait([clearUserModel(), saveGuestSession(false)]);
  }

  static Box<dynamic> _requireBox(Box<dynamic>? box) {
    if (box == null || !box.isOpen) {
      throw StateError(
        'HiveServiceImpl is not initialized. '
        'Call HiveServiceImpl.init() before using the cache.',
      );
    }
    return box;
  }
}
