import 'package:equatable/equatable.dart';

class DiscountCodeModel extends Equatable {
  final int? iD;
  final String? discountCode;
  final double? discountValue;
  final num? discountPercent;
  final String? fromDate;
  final String? toDate;

  const DiscountCodeModel({
    this.iD,
    this.discountCode,
    this.discountValue,
    this.discountPercent,
    this.fromDate,
    this.toDate,
  });

  factory DiscountCodeModel.fromJson(Map<String, dynamic> json) {
    return DiscountCodeModel(
      iD: (json['ID'] as num?)?.toInt(),
      discountCode: json['DiscountCode']?.toString(),
      discountValue: (json['DiscountValue'] as num?)?.toDouble(),
      discountPercent: json['DiscountPercent'] as num?,
      fromDate: json['FromDate']?.toString(),
      toDate: json['ToDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'ID': iD,
    'DiscountCode': discountCode,
    'DiscountValue': discountValue,
    'DiscountPercent': discountPercent,
    'FromDate': fromDate,
    'ToDate': toDate,
  };

  double discountFor(double subtotal) {
    if (subtotal <= 0) return 0;
    final value = discountValue ?? 0;
    final percent = discountPercent ?? 0;
    final double amount;
    if (value > 0) {
      amount = value;
    } else if (percent > 0) {
      amount = subtotal * percent / 100;
    } else {
      amount = 0;
    }
    return amount.clamp(0, subtotal).toDouble();
  }

  bool isActiveOn(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final from = _day(fromDate);
    final to = _day(toDate);
    if (from != null && today.isBefore(from)) return false;
    if (to != null && today.isAfter(to)) return false;
    return true;
  }

  static DateTime? _day(String? value) {
    final parsed = value == null ? null : DateTime.tryParse(value);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  @override
  List<Object?> get props => [
    iD,
    discountCode,
    discountValue,
    discountPercent,
    fromDate,
    toDate,
  ];
}
