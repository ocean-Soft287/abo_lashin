import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:abolashin/features/cart/presentation/widgets/counter_box_component.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';

class SwipeToDeleteCartItem extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDelete;

  const SwipeToDeleteCartItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Dismissible(
      key: ValueKey('cart-${item.barcode}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: const SizedBox.shrink(),
      secondaryBackground: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsetsDirectional.only(end: AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.danger,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: colors.onDanger),
            SizedBox(height: 2.h),
            Text(
              'swipe_to_delete'.tr(),
              style: GoogleFonts.alexandria(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: colors.onDanger,
              ),
            ),
          ],
        ),
      ),
      child: CartItemCard(item: item),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isArabic = context.locale.languageCode == 'ar';
    final hasDiscount = item.priceBeforeDiscount != item.priceAfterDiscount;
    final currency = 'currency'.tr();

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 76.w,
                height: 76.h,
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: ProductTileImage(url: item.image),
              ),
              if (hasDiscount)
                PositionedDirectional(
                  top: 0,
                  start: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.danger,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(AppRadius.md),
                        bottomEnd: Radius.circular(AppRadius.sm),
                      ),
                    ),
                    child: Text(
                      'special_offer'.tr(),
                      style: GoogleFonts.alexandria(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.onDanger,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? item.nameAr : item.nameEn,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Wrap(
                  spacing: 6.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${formatPrice(item.priceAfterDiscount)}$currency',
                      style: GoogleFonts.alexandria(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                    if (hasDiscount)
                      Text(
                        formatPrice(item.priceBeforeDiscount),
                        style: GoogleFonts.alexandria(
                          fontSize: 11.sp,
                          color: colors.textHint,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: colors.textHint,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: formatPrice(
                                  item.priceAfterDiscount * item.quantity,
                                ),
                                style: GoogleFonts.alexandria(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                  color: colors.primary,
                                ),
                              ),
                              TextSpan(
                                text: currency,
                                style: GoogleFonts.alexandria(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    CounterBox(
                      filled: true,
                      barcode: item.barcode,
                      customerQuantity: item.customerQuantity,
                      stockQuantity: item.stockQuantity,
                      image: item.image,
                      nameAr: item.nameAr,
                      nameEn: item.nameEn,
                      priceAfterDiscount: item.priceAfterDiscount,
                      priceBeforeDiscount: item.priceBeforeDiscount,
                      productId: item.productId,
                      customerquntatiy: item.customerQuantity,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
