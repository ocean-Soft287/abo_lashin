part of 'hive_service_impl.dart';

abstract interface class IUserCache {
  Future<void> cacheUserModel(dynamic user);

  dynamic getCachedUserModel();

  Future<void> updateCachedUserModel(dynamic user);

  Future<void> clearUserModel();
}
