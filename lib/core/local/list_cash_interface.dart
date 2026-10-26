part of 'hive_service_impl.dart';

abstract interface class IListCache {
  Future<List<dynamic>?> readList(String boxName, String key);

  Future<void> saveList(String boxName, String key, List<dynamic> list);

  Future<void> deleteList(String boxName, String key);
}
