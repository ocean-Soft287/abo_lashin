import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/features/cart/presentation/widgets/counter_box_component.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/widgets/product_units.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Cart quantity of one sales unit, with the same add/remove rules and
/// per-order limits as [CounterBox].
class ProductQuantityStepper extends StatelessWidget {
  final UnitsModel unit;
  final int productId;
  final String productArName;
  final String productEnName;
  final String image;

  const ProductQuantityStepper({
    super.key,
    required this.unit,
    required this.productId,
    required this.productArName,
    required this.productEnName,
    required this.image,
  });

  static double get height => 48.h;

  Future<void> _add(BuildContext context) async {
    final cart = context.read<CartCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final colors = context.colors;
    await cart.addItem(
      ProductUnits.cartItemFor(
        unit: unit,
        productId: productId,
        productArName: productArName,
        productEnName: productEnName,
        image: image,
      ),
    );
    if (cart.state is! CartFailure) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colors.danger,
          content: Text('add_to_cart_failed'.tr()),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cart = context.read<CartCubit>();
    return BlocSelector<CartCubit, CartState, int>(
      selector:
          (_) => cart.cartItems
              .where((item) => item.barcode == unit.barcode)
              .fold<int>(0, (sum, item) => sum + item.quantity),
      builder: (context, quantity) {
        final canAdd = CounterBox.canAddMore(
          stockQuantity: unit.stockQty,
          customerQuantity: unit.customerQuantity,
          itemCount: quantity,
        );
        return Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          // Minus on the left and plus on the right in both directions.
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepButton(
                icon: Icons.remove_rounded,
                tooltip: 'decrease_quantity'.tr(),
                color: quantity > 0 ? colors.textSecondary : colors.textHint,
                onTap:
                    quantity > 0 ? () => cart.removeItem(unit.barcode) : null,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 36.w),
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alexandria(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              _StepButton(
                icon: Icons.add_rounded,
                tooltip: canAdd ? 'add_to_cart'.tr() : 'limit_reached'.tr(),
                color: canAdd ? colors.success : colors.textHint,
                onTap: canAdd ? () => _add(context) : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onTap;

  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      iconSize: 26.r,
      color: color,
      disabledColor: color,
      constraints: BoxConstraints(minWidth: 44.w, minHeight: 44.h),
      icon: Icon(icon),
    );
  }
}
