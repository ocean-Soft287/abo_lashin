import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/widget/widgets/launch_feedback.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/widgets/product_details_sections.dart';
import 'package:abolashin/features/products/presentation/widgets/product_units.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Every sales unit of the product with what the backend returns for it.
/// The API sends no size, volume or weight per unit, so only price,
/// contents (`UnitValue`), barcode, stock, order limit and offer appear,
/// each only when set.
class ProductUnitsSection extends StatelessWidget {
  final List<UnitsModel> units;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ProductUnitsSection({
    super.key,
    required this.units,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = ProductUnits.baseUnit(units);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: colors.secondary,
              size: 24.r,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'product_units'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        for (var i = 0; i < units.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.md),
          _UnitDetailsCard(
            key: ValueKey('unit-details-${units[i].barcode}-$i'),
            unit: units[i],
            units: units,
            isBase: base != null && identical(base, units[i]),
            selected: i == selectedIndex,
            onTap: units.length > 1 ? () => onSelect(i) : null,
          ),
        ],
      ],
    );
  }
}

class _UnitDetailsCard extends StatelessWidget {
  final UnitsModel unit;
  final List<UnitsModel> units;
  final bool isBase;
  final bool selected;
  final VoidCallback? onTap;

  const _UnitDetailsCard({
    super.key,
    required this.unit,
    required this.units,
    required this.isBase,
    required this.selected,
    this.onTap,
  });

  /// "12 علبة" when a base unit exists; otherwise the bare count of base
  /// units, whose name the API does not send.
  String? _contents(bool isArabic) {
    final factor = unit.unitValue;
    if (isBase || factor == null || factor <= 1) return null;
    return ProductUnits.contents(unit, units, isArabic: isArabic) ??
        'base_units_count'.tr(args: [DetailsFormat.quantity(factor)]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isArabic = context.locale.languageCode == 'ar';
    final name =
        DetailsFormat.localized(isArabic, unit.unitArName, unit.unitEnName) ??
        '—';
    final discount = ProductUnits.discountPercent(unit);
    final contents = _contents(isArabic);
    final factor = unit.unitValue;
    final barcode = DetailsFormat.text(unit.barcode);
    final radius = BorderRadius.circular(AppRadius.lg);

    final rows = <Widget>[
      _InfoRow(
        label: 'unit_price'.tr(),
        value: formatPriceWithCurrency(unit.priceAfterDiscount),
        emphasize: true,
        trailing:
            discount == null
                ? null
                : Text(
                  formatPriceWithCurrency(unit.price),
                  style: GoogleFonts.alexandria(
                    fontSize: 11.5.sp,
                    color: colors.textHint,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: colors.textHint,
                  ),
                ),
      ),
      if (contents != null)
        _InfoRow(label: 'unit_contents'.tr(), value: contents),
      if (factor != null && factor > 0)
        _InfoRow(
          label: 'conversion_factor'.tr(),
          value: '×${DetailsFormat.quantity(factor)}',
          ltrValue: true,
        ),
      if (barcode != null)
        _InfoRow(
          label: 'barcode'.tr(),
          value: barcode,
          ltrValue: true,
          trailing: IconButton(
            tooltip: '${'copy'.tr()} ${'barcode'.tr()}',
            visualDensity: VisualDensity.compact,
            iconSize: 16.r,
            color: colors.textSecondary,
            onPressed: () => copyToClipboard(context, barcode),
            icon: const Icon(Icons.copy_rounded),
          ),
        ),
      // Negative stock is oversold, not a quantity worth showing.
      if (unit.stockQty > 0)
        _InfoRow(
          label: 'available_stock'.tr(),
          value: DetailsFormat.quantity(unit.stockQty),
        ),
      if (unit.customerQuantity > 0)
        _InfoRow(
          label: 'order_limit'.tr(),
          value: DetailsFormat.quantity(unit.customerQuantity),
        ),
      if (unit.requiredQty > 0 && unit.giftQty > 0)
        _InfoRow(
          label: 'unit_offer'.tr(),
          value: 'buy_get_free'.tr(
            args: ['${unit.requiredQty}', '${unit.giftQty}'],
          ),
        ),
    ];

    return Semantics(
      selected: selected,
      button: onTap != null,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: selected ? colors.primary : colors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.alexandria(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: selected ? colors.primary : colors.textPrimary,
                      ),
                    ),
                    if (isBase)
                      InfoChip(
                        label: 'base_unit'.tr(),
                        background: colors.primarySoft,
                        foreground: colors.primary,
                      ),
                    if (discount != null)
                      InfoChip(
                        label: 'unit_discount'.tr(args: ['$discount']),
                        background: colors.dangerSoft,
                        foreground: colors.danger,
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Divider(height: AppSpacing.lg, color: colors.border),
                ...rows,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Label on the start side, value on the end side; the value wraps under
/// long labels instead of overflowing.
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;
  final bool ltrValue;
  final Widget? trailing;

  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    this.ltrValue = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 34.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.alexandria(
                fontSize: 12.5.sp,
                color: colors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Flexible(
            flex: 2,
            child: Text(
              value,
              // Codes read left to right but stay on the row's outer edge.
              textAlign:
                  !ltrValue
                      ? TextAlign.end
                      : Directionality.of(context) == TextDirection.rtl
                      ? TextAlign.left
                      : TextAlign.right,
              textDirection: ltrValue ? TextDirection.ltr : null,
              style: GoogleFonts.alexandria(
                fontSize: (emphasize ? 14 : 13).sp,
                fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
                color: emphasize ? colors.primary : colors.textPrimary,
              ),
            ),
          ),
          if (trailing != null) ...[SizedBox(width: AppSpacing.sm), trailing!],
        ],
      ),
    );
  }
}
