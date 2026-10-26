import 'package:easy_localization/easy_localization.dart' hide TextDirection;

/// Null-safe presentation helpers for the loosely typed details payload.
abstract final class DetailsFormat {
  static final NumberFormat _quantity = NumberFormat('#,##0.###', 'en');
  static final DateFormat _date = DateFormat('dd/MM/yyyy', 'en');

  static String? text(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }

  /// The value for the current language, falling back to the other one.
  static String? localized(bool isArabic, dynamic ar, dynamic en) =>
      isArabic ? text(ar) ?? text(en) : text(en) ?? text(ar);

  static num? number(dynamic value) =>
      value is num ? value : num.tryParse(text(value) ?? '');

  static String quantity(num value) => _quantity.format(value);

  /// Formats [value] only when it is a positive number.
  static String? positive(dynamic value) {
    final n = number(value);
    return n == null || n <= 0 ? null : quantity(n);
  }

  static String? percent(dynamic value) {
    final n = positive(value);
    return n == null ? null : '$n%';
  }

  static DateTime? parseDate(dynamic value) {
    final date = DateTime.tryParse(text(value) ?? '');
    // Treat SQL Server's default date (1900-01-01) as unset.
    return date == null || date.year <= 1900 ? null : date;
  }

  static String? date(dynamic value) {
    final date = parseDate(value);
    return date == null ? null : _date.format(date);
  }
}
