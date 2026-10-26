import 'package:abolashin/core/network/failure.dart';

/// The backend refused the coupon and explained why; [message] is the
/// backend's own text and is safe to show to the user as-is.
class CouponRejectedFailure extends ValidationFailure {
  const CouponRejectedFailure({
    required super.message,
    super.statusCode,
    super.data,
  });
}
