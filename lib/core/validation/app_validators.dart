import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_regex.dart';

abstract final class AppValidators {
  AppValidators._();

  static String _t(BuildContext context, String key) {
    return key.tr(context: context);
  }

  static String? Function(String?) required(
    BuildContext context, {
    String? messageKey,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return _t(context, messageKey ?? 'validation.required');
      }
      return null;
    };
  }

  static String? Function(String?) email(BuildContext context) {
    return (value) {
      final v = value?.trim() ?? '';
      if (v.isEmpty) return _t(context, 'validation.email_required');
      if (!AppRegex.email.hasMatch(v)) {
        return _t(context, 'validation.email_invalid');
      }
      return null;
    };
  }

  static String? Function(String?) egyptianPhone(BuildContext context) {
    return (value) {
      final v = value?.trim() ?? '';
      if (v.isEmpty) return _t(context, 'validation.phone_required');
      if (!AppRegex.egyptPhone.hasMatch(v)) {
        return _t(context, 'validation.phone_invalid');
      }
      return null;
    };
  }

  static String? Function(String?) phone(BuildContext context) {
    return (value) {
      final v = value?.trim() ?? '';
      if (v.isEmpty) return _t(context, 'validation.phone_required');
      if (!AppRegex.internationalPhone.hasMatch(v)) {
        return _t(context, 'validation.phone_invalid');
      }
      return null;
    };
  }

  static String? Function(String?) fullName(BuildContext context) {
    return (value) {
      final v = value?.trim() ?? '';
      if (v.isEmpty) return _t(context, 'validation.name_required');
      if (v.length < 3) return _t(context, 'validation.name_too_short');
      if (!AppRegex.lettersAndSpaces.hasMatch(v)) {
        return _t(context, 'validation.name_invalid');
      }
      return null;
    };
  }

  static String? Function(String?) companyName(BuildContext context) {
    return (value) {
      final v = value?.trim() ?? '';
      if (v.isEmpty) return _t(context, 'validation.company_required');
      if (v.length < 2) return _t(context, 'validation.company_too_short');
      return null;
    };
  }

  static String? Function(String?) minLength(
    BuildContext context, {
    required int min,
    String? messageKey,
  }) {
    return (value) {
      final v = value ?? '';
      if (v.isEmpty) return _t(context, 'validation.required');
      if (v.length < min) {
        return _t(context, messageKey ?? 'validation.too_short');
      }
      return null;
    };
  }

  static String? Function(String?) maxLength(
    BuildContext context, {
    required int max,
    String? messageKey,
  }) {
    return (value) {
      final v = value ?? '';
      if (v.isEmpty) return _t(context, 'validation.required');
      if (v.length > max) {
        return _t(context, messageKey ?? 'validation.too_long');
      }
      return null;
    };
  }

  static String? Function(String?) password(BuildContext context) {
    return (value) {
      final v = value ?? '';
      if (v.isEmpty) return _t(context, 'validation.password_required');
      if (v.length < 6) return _t(context, 'validation.password_too_short');
      if (v.length > 20) return _t(context, 'validation.password_too_long');
      if (AppRegex.hasWhitespace.hasMatch(v)) {
        return _t(context, 'validation.password_no_spaces');
      }
      if (AppRegex.hasRepeatingChars.hasMatch(v)) {
        return _t(context, 'validation.password_repeating');
      }
      if (AppRegex.hasSequentialChars.hasMatch(v)) {
        return _t(context, 'validation.password_sequential');
      }
      if (_countCharTypes(v) < 2) {
        return _t(context, 'validation.password_mixed_types');
      }
      return null;
    };
  }

  static String? Function(String?) confirmPassword(
    BuildContext context,
    String Function() passwordGetter,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return _t(context, 'validation.confirm_password_required');
      }
      if (value != passwordGetter()) {
        return _t(context, 'validation.password_mismatch');
      }
      return null;
    };
  }

  static String? Function(String?) otp(BuildContext context, {int length = 4}) {
    return (value) {
      final v = value?.trim() ?? '';
      if (v.isEmpty) return _t(context, 'validation.otp_required');
      if (v.length != length) return _t(context, 'validation.otp_invalid');
      if (!AppRegex.digitsOnly.hasMatch(v)) {
        return _t(context, 'validation.otp_invalid');
      }
      return null;
    };
  }

  static String? Function(String?) country(BuildContext context) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return _t(context, 'validation.country_required');
      }
      return null;
    };
  }

  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final v in validators) {
        final result = v(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  static int _countCharTypes(String value) {
    var types = 0;
    if (RegExp(r'[a-z]').hasMatch(value)) types++;
    if (RegExp(r'[A-Z]').hasMatch(value)) types++;
    if (AppRegex.hasDigit.hasMatch(value)) types++;
    if (AppRegex.hasSpecial.hasMatch(value)) types++;
    return types;
  }
}
