import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:abolashin/features/cart/presentation/widgets/cart_widget.dart';
import 'package:abolashin/features/cart/presentation/widgets/checkout_summary.dart';
import 'package:abolashin/features/cart/presentation/widgets/custom_button_sheet.dart';
import 'package:abolashin/features/cart/presentation/widgets/delivery_address_bar.dart';
import 'package:abolashin/features/cart/presentation/widgets/empty_cart_view.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_state.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // The local cart is already shown; this only merges in the Sales Basket.
    context.read<CartCubit>().syncWithServer();
  }

  Future<void> _openAddressSheet(AddOrderCubit addOrderCubit) async {
    if (!await context.ensureSignedIn()) return;
    if (!mounted) return;
    // Adding an address reloads the list itself.
    if (addOrderCubit.allAddressList.isEmpty) addOrderCubit.getAllAddress();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CustomButtonSheet(addOrderCubit: addOrderCubit),
    );
  }

  void _deleteItem(String barcode) {
    final cartCubit = context.read<CartCubit>();
    final removed = cartCubit.deleteItem(barcode);
    if (removed == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('item_removed_from_cart'.tr()),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'undo'.tr(),
            onPressed: () => cartCubit.restoreItem(removed.index, removed.item),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (context.read<CartCubit>().cartItems.isEmpty) {
          context.read<CouponCubit>().remove();
        }
      },
      // Each part below listens only to what it shows, so a quantity change
      // rebuilds that line and the totals, not the whole screen.
      child: BlocSelector<AddOrderCubit, AddOrderState, bool>(
        selector: (state) => state is GetCustomerSalesBasketLoading,
        builder: (context, loading) {
          final addOrderCubit = context.read<AddOrderCubit>();
          final cartCubit = context.read<CartCubit>();
          return Column(
            children: [
              BlocSelector<CartCubit, CartState, int>(
                selector: (_) => cartCubit.cartItems.length,
                builder: (context, count) => _CartHeader(count: count),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: BlocBuilder<AddOrderCubit, AddOrderState>(
                  builder:
                      (context, _) => DeliveryAddressBar(
                        address: addOrderCubit.selectedAddress,
                        loading:
                            addOrderCubit.addressesLoading &&
                            addOrderCubit.allAddressList.isEmpty,
                        failed:
                            addOrderCubit.addressesFailure != null &&
                            addOrderCubit.allAddressList.isEmpty,
                        onTap: () => _openAddressSheet(addOrderCubit),
                      ),
                ),
              ),
              Expanded(
                child:
                    loading
                        ? const SkeletonizerCart()
                        : _CartLines(onDelete: _deleteItem),
              ),
              if (!loading)
                BlocSelector<CartCubit, CartState, bool>(
                  selector: (_) => cartCubit.cartItems.isNotEmpty,
                  builder:
                      (context, hasItems) =>
                          hasItems
                              ? CheckoutSummary(
                                addOrderCubit: addOrderCubit,
                                onSelectAddress:
                                    () => _openAddressSheet(addOrderCubit),
                              )
                              : const SizedBox.shrink(),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// The cart lines. The list rebuilds only when lines are added, removed or
/// reordered; a quantity change rebuilds just its own [_CartLine].
class _CartLines extends StatefulWidget {
  final ValueChanged<String> onDelete;

  const _CartLines({required this.onDelete});

  @override
  State<_CartLines> createState() => _CartLinesState();
}

class _CartLinesState extends State<_CartLines> {
  List<String> _barcodes = const [];

  List<String> _currentBarcodes() => [
    for (final item in context.read<CartCubit>().cartItems) item.barcode,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (_, _) => !listEquals(_barcodes, _currentBarcodes()),
      builder: (context, _) {
        final barcodes = _barcodes = _currentBarcodes();
        if (barcodes.isEmpty) return const EmptyCartView();
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.lg,
          ),
          itemCount: barcodes.length,
          itemBuilder:
              (context, i) => _CartLine(
                key: ValueKey(barcodes[i]),
                barcode: barcodes[i],
                onDelete: widget.onDelete,
              ),
          separatorBuilder: (context, i) => SizedBox(height: AppSpacing.md),
        );
      },
    );
  }
}

class _CartLine extends StatelessWidget {
  final String barcode;
  final ValueChanged<String> onDelete;

  const _CartLine({super.key, required this.barcode, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    return BlocSelector<CartCubit, CartState, CartItem?>(
      selector: (_) => cartCubit.lineWithBarcode(barcode),
      builder:
          (context, item) =>
              item == null
                  ? const SizedBox.shrink()
                  : SwipeToDeleteCartItem(
                    item: item,
                    onDelete: () => onDelete(barcode),
                  ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  final int count;

  const _CartHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'cart'.tr(),
              style: GoogleFonts.alexandria(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (count > 0)
            InfoChip(
              icon: Icons.shopping_bag_outlined,
              label: '$count ${'items_count'.tr()}',
              background: context.colors.primarySoft,
              foreground: context.colors.primary,
            ),
        ],
      ),
    );
  }
}
