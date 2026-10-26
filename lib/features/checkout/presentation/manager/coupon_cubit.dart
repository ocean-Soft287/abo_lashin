import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/checkout/data/datasource/checkout_data_source.dart';
import 'package:abolashin/features/checkout/data/model/coupon_rejected_failure.dart';
import 'package:abolashin/features/checkout/data/model/discount_code_model.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  CouponCubit({CheckoutDataSource? dataSource, DateTime Function()? clock})
    : _dataSource = dataSource ?? getIt<CheckoutDataSource>(),
      _clock = clock ?? DateTime.now,
      super(const CouponState());

  final CheckoutDataSource _dataSource;
  final DateTime Function() _clock;
  int _request = 0;

  Future<void> apply(String rawCode) async {
    final code = rawCode.trim();
    if (code.isEmpty || state.isLoading) return;
    if (state.isApplied && _same(state.code, code)) return;
    await _validate(code);
  }

  Future<void> revalidate() async {
    if (!state.isApplied || state.isLoading) return;
    await _validate(state.code);
  }

  void remove() {
    _request++;
    if (!isClosed) emit(const CouponState());
  }

  Future<void> _validate(String code) async {
    final request = ++_request;
    emit(CouponState(status: CouponStatus.loading, code: code));
    final result = await _dataSource.getCoupon(code);
    if (isClosed || request != _request) return;
    result.fold(
      (failure) => emit(
        failure is CouponRejectedFailure
            ? CouponState(
              status: CouponStatus.invalid,
              code: code,
              message: failure.message,
            )
            : CouponState(
              status: CouponStatus.failure,
              code: code,
              failure: failure,
            ),
      ),
      (coupons) {
        final match = _match(coupons, code);
        if (match == null) {
          emit(CouponState(status: CouponStatus.invalid, code: code));
        } else if (!match.isActiveOn(_clock())) {
          emit(CouponState(status: CouponStatus.expired, code: code));
        } else {
          emit(
            CouponState(
              status: CouponStatus.applied,
              code: match.discountCode ?? code,
              coupon: match,
            ),
          );
        }
      },
    );
  }

  static DiscountCodeModel? _match(
    List<DiscountCodeModel> coupons,
    String code,
  ) {
    for (final coupon in coupons) {
      if (_same(coupon.discountCode ?? '', code)) return coupon;
    }
    return coupons.length == 1 && coupons.first.discountCode == null
        ? coupons.first
        : null;
  }

  static bool _same(String a, String b) =>
      a.trim().toLowerCase() == b.trim().toLowerCase();
}
