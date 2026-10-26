import 'package:equatable/equatable.dart';

import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/checkout/data/model/discount_code_model.dart';

enum CouponStatus { idle, loading, applied, invalid, expired, failure }

class CouponState extends Equatable {
  final CouponStatus status;
  final String code;
  final DiscountCodeModel? coupon;
  final Failure? failure;

  /// Rejection text returned by the backend; shown instead of [errorKey].
  final String? message;

  const CouponState({
    this.status = CouponStatus.idle,
    this.code = '',
    this.coupon,
    this.failure,
    this.message,
  });

  bool get isLoading => status == CouponStatus.loading;

  bool get isApplied => status == CouponStatus.applied && coupon != null;

  double discountFor(double subtotal) =>
      isApplied ? coupon!.discountFor(subtotal) : 0;

  String? get errorKey => switch (status) {
    CouponStatus.invalid => 'coupon_invalid',
    CouponStatus.expired => 'coupon_expired',
    CouponStatus.failure => failure?.messageKey ?? 'error_unknown',
    _ => null,
  };

  @override
  List<Object?> get props => [status, code, coupon, failure, message];
}
