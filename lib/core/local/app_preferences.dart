import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String languageKey = 'changeLang';
  static const String themeModeKey = 'theme_mode';
  static const String defaultLanguage = 'ar';
  static const String selectedAddressKey = 'selected_address';

  static const String legacyCustomerIdKey = 'customerID';
  static const String legacyCustomerNameKey = 'customerName';
  static const String legacyCustomerPhoneKey = 'customerPhone';

  final SharedPreferences _preferences;

  const AppPreferences(this._preferences);

  String get languageCode {
    final value = _preferences.getString(languageKey);
    return value == null || value.isEmpty ? defaultLanguage : value;
  }

  Future<void> saveLanguageCode(String code) =>
      _preferences.setString(languageKey, code);

  ThemeMode get themeMode {
    final value = _preferences.getString(themeModeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      // Default to the light (white) theme until the user picks one.
      orElse: () => ThemeMode.light,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) =>
      _preferences.setString(themeModeKey, mode.name);

  /// The delivery address a customer chose explicitly, by its `AddressID`.
  String? selectedAddressId(int customerId) =>
      _preferences.getString('${selectedAddressKey}_$customerId');

  Future<void> saveSelectedAddressId(int customerId, String? addressId) {
    final key = '${selectedAddressKey}_$customerId';
    return addressId == null
        ? _preferences.remove(key)
        : _preferences.setString(key, addressId);
  }

  Object? get legacyCustomerId => _preferences.get(legacyCustomerIdKey);

  Object? get legacyCustomerPhone => _preferences.get(legacyCustomerPhoneKey);

  Object? get legacyCustomerName => _preferences.get(legacyCustomerNameKey);

  Future<void> clearLegacySession() async {
    await _preferences.remove(legacyCustomerIdKey);
    await _preferences.remove(legacyCustomerPhoneKey);
    await _preferences.remove(legacyCustomerNameKey);
  }
}
