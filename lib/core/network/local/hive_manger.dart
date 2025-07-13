import 'package:hive/hive.dart';
class HiveCrudManager {



  static Future<Box> _openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }

  static Future<void> saveList(String boxName, String key, List<dynamic> list) async {
    final box = await _openBox(boxName);
    await box.put(key, list);
  }

  static Future<List<dynamic>?> readList(String boxName, String key) async {
    final box = await _openBox(boxName);
    return box.get(key) as List<dynamic>?;
  }

  static Future<void> updateList(String boxName, String key, List<dynamic> updatedList) async {
    final box = await _openBox(boxName);
    await box.put(key, updatedList);
  }

  static Future<void> deleteList(String boxName, String key) async {
    final box = await _openBox(boxName);
    await box.delete(key);
  }

  static Future<Map<dynamic, dynamic>> readAll(String boxName) async {
    final box = await _openBox(boxName);
    return box.toMap();
  }
}