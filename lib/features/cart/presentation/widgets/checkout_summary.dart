import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/connectivity/connectivity_service.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_state.dart';
import 'package:abolashin/features/addresses/presentation/screen/add_new_address_screen.dart';
import 'package:abolashin/features/checkout/presentation/screen/add_order_screen.dart';
import 'package:abolashin/features/checkout/presentation/widgets/inactive_account_dialog.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/features/cart/presentation/widgets/coupon_section.dart';

class CheckoutSummary extends StatefulWidget {
  final AddOrderCubit addOrderCubit;

  final VoidCallback onSelectAddress;

  const CheckoutSummary({
    super.key,
    required this.addOrderCubit,
    required this.onSelectAddress,
  });

  @override
  State<CheckoutSummary> createState() => _CheckoutSummaryState();
}

class _CheckoutSummaryState extends State<CheckoutSummary> {
  bool _checking = false;

  Future<void> _checkout() async {
    if (!await context.ensureSignedIn()) return;
    if (!mounted) return;
    if (!ConnectivityService.instance.isOnline) {
      _showError('requires_connection'.tr());
      return;
    }
    final addOrderCubit = widget.addOrderCubit;
    // The button is disabled while addresses load; this covers a load that
    // started during the checks above.
    if (addOrderCubit.addressesLoading) return;
    final address = addOrderCubit.selectedAddress;
    if (address == null || !addOrderCubit.hasValidAddress) {
      _requireAddress(addOrderCubit);
      return;
    }
    final cartCubit = context.read<CartCubit>();

    // Refetch the cart from the server before checking out, so the order is
    // placed against the latest basket contents.
    setState(() => _checking = true);
    await cartCubit.syncWithServer();
    if (!mounted) return;

    // Read now: the refresh above may have changed the cart.
    final cartItems = cartCubit.cartItems;
    if (cartItems.isEmpty) {
      setState(() => _checking = false);
      return;
    }
    final totalPrice = cartCubit.calculateTotalPrice();
    final minimum = addOrderCubit.minimumOrderValue;
    if (minimum == null) {
      setState(() => _checking = false);
      _showError('error_unexpected_response'.tr());
      return;
    }
    final remaining = _remainingForMinimum(totalPrice, minimum);
    if (remaining > 0) {
      setState(() => _checking = false);
      _showError(_minimumOrderMessage(minimum, remaining));
      return;
    }

    final result = await addOrderCubit.verifyCustomerIsActive();
    if (!mounted) return;
    setState(() => _checking = false);

    final Failure? failure = result.fold((failure) => failure, (_) => null);
    if (failure != null) {
      _showError(failure.messageKey.tr());
      return;
    }
    final isActive = result.fold((_) => false, (active) => active);

    if (isActive) {
      context.pushScreen(
        AddOrderScreen(
          listItemName: cartItems,
          allAddressModel: address,
          listItem: cartItems.map((item) => item.toMap()).toList(),
          total: totalPrice,
          address: address.address.toString(),
        ),
      );
    } else {
      showInactiveAccountDialog(context);
    }
  }

  void _requireAddress(AddOrderCubit addOrderCubit) {
    if (addOrderCubit.allAddressList.isNotEmpty) {
      _showError('choose_address_to_checkout'.tr());
      widget.onSelectAddress();
      return;
    }
    if (addOrderCubit.addressesFailure != null) {
      _showError('addresses_load_failed'.tr());
      addOrderCubit.getAllAddress();
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('address_required_to_checkout'.tr()),
          backgroundColor: context.colors.danger,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'add_address'.tr(),
            textColor: context.colors.onDanger,
            // Opened over the cart, so the add screen closes back to it.
            onPressed:
                () => context.pushScreen(
                  const AddNewAddress(isSavedAddressPage: true),
                ),
          ),
        ),
      );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.colors.danger,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds when the selected address changes; its minimum order applies.
    final minimum = context.select<AddOrderCubit, double?>(
      (cubit) => cubit.minimumOrderValue,
    );
    final addressesLoading = context.select<AddOrderCubit, bool>(
      (cubit) => cubit.addressesLoading,
    );
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (_, current) => current is! CartLoading,
      builder: (context, state) {
        if (state is CartFailure) {
          return Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text(
              (state.failure?.messageKey ?? 'error_unknown').tr(),
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                color: context.colors.danger,
              ),
            ),
          );
        }

        final subtotal = context.read<CartCubit>().calculateTotalPrice();
        final remaining =
            minimum == null ? 0.0 : _remainingForMinimum(subtotal, minimum);

        return Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow,
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BlocBuilder<CouponCubit, CouponState>(
            builder: (context, coupon) {
              final discount = coupon.discountFor(subtotal);
              final payable = (subtotal - discount).clamp(0, double.infinity);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CouponSection(subtotal: subtotal),
                  SizedBox(height: AppSpacing.sm),
                  if (remaining > 0)
                    _MinimumOrderHint(minimum: minimum!, remaining: remaining),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _TotalColumn(
                          subtotal: subtotal,
                          discount: discount,
                          payable: payable.toDouble(),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 6,
                        child: FilledButton.icon(
                          onPressed:
                              _checking || coupon.isLoading || addressesLoading
                                  ? null
                                  : _checkout,
                          icon:
                              _checking
                                  ? SizedBox(
                                    width: 18.w,
                                    height: 18.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: context.colors.primary,
                                    ),
                                  )
                                  : const Icon(Icons.shopping_bag_outlined),
                          label: Text(
                            'complete_purchase'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

/// How much more [total] needs to reach [minimum], compared at the two
/// decimals prices are shown with; 0 when the minimum is met.
double _remainingForMinimum(double total, double minimum) {
  final remaining = ((minimum - total) * 100).round() / 100;
  return remaining > 0 ? remaining : 0;
}

String _minimumOrderMessage(double minimum, double remaining) =>
    'minimum_order_not_reached'.tr(
      args: [
        formatPriceWithCurrency(minimum),
        formatPriceWithCurrency(remaining),
      ],
    );

class _MinimumOrderHint extends StatelessWidget {
  final double minimum;
  final double remaining;

  const _MinimumOrderHint({required this.minimum, required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.r,
            color: context.colors.secondary,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              _minimumOrderMessage(minimum, remaining),
              style: GoogleFonts.alexandria(
                fontSize: 11.sp,
                color: context.colors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalColumn extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double payable;

  const _TotalColumn({
    required this.subtotal,
    required this.discount,
    required this.payable,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasDiscount = discount > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                (hasDiscount ? 'total_after_discount' : 'subtotal').tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.alexandria(
                  fontSize: 12.sp,
                  color: colors.textSecondary,
                ),
              ),
            ),
            if (hasDiscount) ...[
              SizedBox(width: 6.w),
              Text(
                formatPrice(subtotal),
                style: GoogleFonts.alexandria(
                  fontSize: 11.sp,
                  color: colors.textHint,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: colors.textHint,
                ),
              ),
            ],
          ],
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: formatPrice(payable),
                  style: GoogleFonts.alexandria(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
                TextSpan(
                  text: 'currency'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
