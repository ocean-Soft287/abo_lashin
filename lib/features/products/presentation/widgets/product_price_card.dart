import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/products/presentation/widgets/product_offer_countdown.dart';

/// Gradient ("blue counter") card with the selected unit's price and, when the
/// product can be ordered, its cart quantity [stepper].
///
/// When the selected unit has a valid discount, [originalPrice] and
/// [discountPercent] are both supplied: the card shows the struck-out original
/// price and, below the price row, a live countdown to the offer's end date
/// ([toDate]). The matching discount badge is shown on the product image, not
/// here, so it is never duplicated. These extras are omitted (null) when no
/// discount applies — the caller decides using the existing pricing rules
/// (original price greater than the discounted price); this widget never infers
/// one, and the date is used only to drive the countdown, never to decide what
/// is shown.
class ProductPriceCard extends StatelessWidget {
  final num price;
  final num? originalPrice;
  final int? discountPercent;
  final String? toDate;
  final Widget? stepper;

  const ProductPriceCard({
    super.key,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.toDate,
    this.stepper,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasDiscount = originalPrice != null && discountPercent != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 76.h,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: AppSpacing.md),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Final price — strongest emphasis.
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            formatPriceWithCurrency(price),
                            maxLines: 1,
                            style: GoogleFonts.alexandria(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.onBrand,
                            ),
                          ),
                        ),
                        if (hasDiscount) ...[
                          SizedBox(height: AppSpacing.xs),
                          // Original price, struck through.
                          Text(
                            formatPriceWithCurrency(originalPrice),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.alexandria(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w500,
                              color: colors.onBrand.withValues(alpha: 0.72),
                              decoration: TextDecoration.lineThrough,
                              decorationColor:
                                  colors.onBrand.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (stepper != null) ...[
                  SizedBox(width: AppSpacing.lg),
                  stepper!,
                ],
              ],
            ),
          ),
          // Countdown to the offer's end date, shown only while the unit is
          // discounted. It hides itself when there is no future date to count
          // to, leaving the card at its plain height.
          if (hasDiscount) ProductOfferCountdown(toDate: toDate),
        ],
      ),
    );
  }
}
