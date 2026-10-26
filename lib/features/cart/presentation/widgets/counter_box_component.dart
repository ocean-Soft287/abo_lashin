import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';

class CounterBox extends StatelessWidget {
  final int productId;
  final String nameAr;
  final String nameEn;
  final double priceBeforeDiscount;
  final double priceAfterDiscount;
  final String image;
  final num customerQuantity;
  final num stockQuantity;
  final String barcode;
  final num customerquntatiy;

  final bool filled;

  final bool wide;

  const CounterBox({
    super.key,
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    required this.priceBeforeDiscount,
    required this.priceAfterDiscount,
    required this.image,
    required this.customerQuantity,
    required this.stockQuantity,
    required this.barcode,
    required this.customerquntatiy,
    this.filled = false,
    this.wide = false,
  });

  bool _canAdd(int itemCount) => canAddMore(
    stockQuantity: stockQuantity,
    customerQuantity: customerQuantity,
    itemCount: itemCount,
  );

  static bool canAddMore({
    required num stockQuantity,
    required num customerQuantity,
    required int itemCount,
  }) {
    return (stockQuantity > 0 &&
            customerQuantity <= 0 &&
            itemCount < stockQuantity) ||
        (customerQuantity > 0 && itemCount < customerQuantity) ||
        (stockQuantity <= 0 &&
            customerQuantity > 0 &&
            itemCount < customerQuantity) ||
        (stockQuantity <= 0 && itemCount < customerQuantity) ||
        (customerQuantity == 0);
  }

  void _addToCart(CartCubit cartCubit) {
    cartCubit.addItem(
      CartItem(
        productId: productId,
        nameAr: nameAr,
        nameEn: nameEn,
        barcode: barcode,
        priceBeforeDiscount: priceBeforeDiscount,
        priceAfterDiscount: priceAfterDiscount,
        image: image,
        stockQuantity: stockQuantity,
        customerQuantity: customerQuantity,
        quantity: customerquntatiy.toInt(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    return BlocSelector<CartCubit, CartState, int>(
      selector:
          (_) => cartCubit.getItemCount(
            productId: productId,
            nameAr: nameAr,
            nameEn: nameEn,
            customerQuantity: customerQuantity,
            stockQuantity: stockQuantity,
            barcode: barcode,
            image: image,
            price: priceBeforeDiscount,
            priceAfterDiscount: priceAfterDiscount,
          ),
      builder: (context, itemCount) {
        final canAdd = _canAdd(itemCount);

        if (filled) {
          return _FilledCounter(
            itemCount: itemCount,
            canAdd: canAdd,
            wide: wide,
            onAdd: () => _addToCart(cartCubit),
            onRemove: () => cartCubit.removeItem(barcode),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IntrinsicWidth(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 30.h,
                padding: EdgeInsets.symmetric(
                  horizontal: itemCount > 0 ? 6.w : 0,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(color: context.colors.shadow, blurRadius: 5),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (itemCount > 0)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.remove,
                          color: context.colors.primary,
                          size: 15.sp,
                        ),
                        onPressed: () => cartCubit.removeItem(barcode),
                      ),
                    if (itemCount > 0)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          '$itemCount',
                          style: TextStyle(color: context.colors.textPrimary),
                        ),
                      ),
                    if (canAdd)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.add,
                          color: context.colors.primary,
                          size: 15.sp,
                        ),
                        onPressed: () => _addToCart(cartCubit),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilledCounter extends StatelessWidget {
  final int itemCount;
  final bool canAdd;
  final bool wide;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _FilledCounter({
    required this.itemCount,
    required this.canAdd,
    required this.wide,
    required this.onAdd,
    required this.onRemove,
  });

  static double get _size => 40.r;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;

    if (itemCount <= 0) {
      if (wide) return _WideAddButton(enabled: canAdd, onTap: onAdd);
      return _SquareButton(
        icon: Icons.add_rounded,
        tooltip: 'add_to_cart'.tr(),
        background: canAdd ? color : context.colors.border,
        foreground: context.colors.onPrimary,
        onTap: canAdd ? onAdd : null,
      );
    }

    final count = Text(
      '$itemCount',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );

    return Container(
      height: _size,
      decoration: BoxDecoration(
        color: context.colors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _SquareButton(
            icon: Icons.remove_rounded,
            background: Colors.transparent,
            foreground: color,
            onTap: onRemove,
          ),
          if (wide)
            Expanded(child: count)
          else
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 18.w),
              child: count,
            ),
          _SquareButton(
            icon: Icons.add_rounded,
            background: canAdd ? color : context.colors.border,
            foreground: context.colors.onPrimary,
            onTap: canAdd ? onAdd : null,
          ),
        ],
      ),
    );
  }
}

class _WideAddButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _WideAddButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      color: context.colors.border,
      child: Ink(
        decoration: BoxDecoration(
          gradient: enabled ? context.colors.primaryGradient : null,
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: SizedBox(
            height: _FilledCounter._size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_shopping_cart_rounded,
                  size: 18.r,
                  color:
                      enabled
                          ? context.colors.onBrand
                          : context.colors.textHint,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    'add_to_cart'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          enabled
                              ? context.colors.onBrand
                              : context.colors.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  const _SquareButton({
    required this.icon,
    required this.background,
    required this.foreground,
    this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: SizedBox(
          width: _FilledCounter._size,
          height: _FilledCounter._size,
          child: Icon(icon, size: 20.r, color: foreground),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
