import 'package:easy_localization/easy_localization.dart';

class AppValidators {
  static bool _isEmpty(String? value) {
    if (value == null) return true;
    return value.trim().isEmpty;
  }

  static String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String? required(String? value, {String? requiredKey}) {
    if (_isEmpty(value)) {
      return (requiredKey ?? "field_required").tr();
    }
    return null;
  }

  static String? password(String? value) {
    if (_isEmpty(value)) return "field_required".tr();
    if (value!.trim().length < 6) return "password_min_6".tr();
    return null;
  }

  static String? mobile(String? value) {
    if (_isEmpty(value)) return "field_required".tr();

    final digits = _digitsOnly(value!);
    if (digits.length != 11) {
      return "mobile_invalid".tr();
    }
    return null;
  }

  static String? nationalId(String? value) {
    if (_isEmpty(value)) return "field_required".tr();

    final digits = _digitsOnly(value!);
    if (digits.length != 14) {
      return "national_id_invalid".tr();
    }
    return null;
  }

  static String? email(String? value) {
    if (_isEmpty(value)) return "field_required".tr();

    final v = value!.trim();

    final emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegExp.hasMatch(v)) {
      return "email_invalid".tr();
    }
    return null;
  }

  static String? fullNameTwoParts(String? value) {
    if (_isEmpty(value)) return "field_required".tr();

    final parts =
        value!.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.length < 2) return "name_two_parts_required".tr();

    if (parts.any((p) => p.length < 2)) {
      return "name_part_too_short".tr();
    }

    return null;
  }

  static String? requiredAndMinLength(
    String? value, {
    required int minLength,
    String? requiredKey,
    String? minKey,
  }) {
    if (_isEmpty(value)) return (requiredKey ?? "field_required").tr();
    if (value!.trim().length < minLength)
      return (minKey ?? "password_min_6").tr();
    return null;
  }
}
