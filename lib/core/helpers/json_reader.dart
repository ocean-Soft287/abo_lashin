abstract final class JsonReader {
  JsonReader._();

  static num? asNum(Object? value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) return num.tryParse(value.trim());
    return null;
  }

  static double? asDouble(Object? value) => asNum(value)?.toDouble();

  static int? asInt(Object? value) {
    final number = asNum(value);
    if (number == null) return null;
    if (number is int) return number;
    return number == number.roundToDouble() ? number.toInt() : null;
  }

  static String? asString(Object? value) {
    if (value == null) return null;
    return value.toString();
  }

  static bool? asBool(Object? value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }

  static List<Map<String, dynamic>> asMapList(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
