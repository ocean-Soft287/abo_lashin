import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/widgets/product_details_sections.dart';
import 'package:abolashin/features/products/presentation/widgets/product_units.dart';

class ProductUnitSelector extends StatelessWidget {
  final List<UnitsModel> units;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ProductUnitSelector({
    super.key,
    required this.units,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isArabic = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_drink_outlined,
              color: colors.secondary,
              size: 26.r,
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              'unit'.tr(),
              style: GoogleFonts.alexandria(
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        _UnitsList(
          units: units,
          selectedIndex: selectedIndex,
          onSelect: onSelect,
          isArabic: isArabic,
        ),
      ],
    );
  }
}

class _UnitsList extends StatelessWidget {
  final List<UnitsModel> units;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool isArabic;

  const _UnitsList({
    required this.units,
    required this.selectedIndex,
    required this.onSelect,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final cardWidth = _getCardWidth(screenWidth);
    final cardHeight = _getCardHeight(context);

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: units.length,
        separatorBuilder: (_, __) => SizedBox(
          width: AppSpacing.md,
        ),
        itemBuilder: (context, index) {
          final unit = units[index];

          return SizedBox(
            width: cardWidth,
            child: _UnitCard(
              key: ValueKey('unit-card-${unit.barcode}-$index'),
              unit: unit,
              contents: ProductUnits.contents(
                unit,
                units,
                isArabic: isArabic,
              ),
              selected: index == selectedIndex,
              onTap: units.length > 1
                  ? () => onSelect(index)
                  : null,
            ),
          );
        },
      ),
    );
  }

  double _getCardWidth(double screenWidth) {
    if (screenWidth >= 1200) {
      return 200.w;
    }

    if (screenWidth >= 800) {
      return 184.w;
    }

    if (screenWidth >= 600) {
      return 168.w;
    }

    return 148.w;
  }

  /// Height sized to exactly fit the tallest card (one that shows a contents
  /// line) given the current OS text scale, so nothing overflows in any
  /// language while unselected cards stay just as compact. The icon row, the
  /// contents row and the price row, their spacings and the vertical padding
  /// are summed from the same metrics the card renders with.
  double _getCardHeight(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);

    // Measure the real painted line height for each row with the exact style
    // the card renders with, so the sum matches the layout to the pixel across
    // fonts, text scales and languages. Glyph choice does not affect the line
    // box, so a fixed sample suffices.
    double textRow(double fontSize) {
      final painter = TextPainter(
        text: TextSpan(
          text: 'Ag',
          style: GoogleFonts.alexandria(
            fontSize: fontSize,
            height: _lineHeight,
          ),
        ),
        textDirection: direction,
        textScaler: scaler,
        maxLines: 1,
      )..layout();
      return painter.height;
    }

    final iconRow = math.max(
      _iconSize,
      math.max(textRow(_nameFontSize), _checkSize),
    );

    // The card border is drawn inside the box, so it insets the content on
    // both edges; the selected card's thicker border is the worst case.
    final content = _selectedBorderWidth * 2 +
        _cardVerticalPadding * 2 +
        iconRow +
        AppSpacing.sm +
        textRow(_contentsFontSize) +
        AppSpacing.xs +
        textRow(_priceFontSize);

    // Round up so the fixed list height is never a sub-pixel below content.
    return content.ceilToDouble() + 1;
  }
}

// Shared card metrics, used both to render the card and to size the list so
// the two can never disagree and overflow.
double get _iconSize => 32.r;
double get _checkSize => 18.r;
double get _cardVerticalPadding => AppSpacing.md;
double get _nameFontSize => 13.sp;
double get _contentsFontSize => 11.sp;
double get _priceFontSize => 14.5.sp;
const double _lineHeight = 1.2;
const double _selectedBorderWidth = 1.6;
const double _unselectedBorderWidth = 1.2;

/// A compact product-variant card: a small icon sits inline beside the unit
/// name on the first row, with the contents and the unit price stacked below.
/// The whole card is the tap target and the selected state is carried by the
/// theme primary colour, not the check alone.
class _UnitCard extends StatelessWidget {
  final UnitsModel unit;
  final String? contents;
  final bool selected;
  final VoidCallback? onTap;

  const _UnitCard({
    super.key,
    required this.unit,
    required this.contents,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isArabic = context.locale.languageCode == 'ar';

    final name = DetailsFormat.localized(
          isArabic,
          unit.unitArName,
          unit.unitEnName,
        ) ??
        '—';

    final radius = BorderRadius.circular(AppRadius.lg);

    final nameStyle = GoogleFonts.alexandria(
      fontSize: _nameFontSize,
      height: _lineHeight,
      fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
      color: selected ? colors.primary : colors.textPrimary,
    );

    final contentsStyle = GoogleFonts.alexandria(
      fontSize: _contentsFontSize,
      height: _lineHeight,
      fontWeight: FontWeight.w500,
      color: colors.textSecondary,
    );

    final priceStyle = GoogleFonts.alexandria(
      fontSize: _priceFontSize,
      height: _lineHeight,
      fontWeight: FontWeight.w800,
      color: selected ? colors.primary : colors.textPrimary,
    );

    return Semantics(
      selected: selected,
      button: onTap != null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          // Unselected cards sit on a neutral muted surface so they read as
          // distinct chips against the white page; the selected card lifts to
          // a subtle primary tint with a primary border.
          color: selected ? colors.primarySoft : colors.surfaceMuted,
          borderRadius: radius,
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: selected ? _selectedBorderWidth : _unselectedBorderWidth,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: _cardVerticalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _UnitIcon(unit: unit, selected: selected),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: nameStyle,
                        ),
                      ),
                      if (selected) ...[
                        SizedBox(width: AppSpacing.sm),
                        _SelectedCheck(colors: colors),
                      ],
                    ],
                  ),
                  if (contents != null) ...[
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      contents!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: contentsStyle,
                    ),
                  ],
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    formatPriceWithCurrency(unit.priceAfterDiscount),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: priceStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small rounded container holding the backend unit image when one is sent,
/// otherwise a neutral Material glyph. Tints to the primary colour when the
/// card is selected.
class _UnitIcon extends StatelessWidget {
  final UnitsModel unit;
  final bool selected;

  const _UnitIcon({required this.unit, required this.selected});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = _iconSize;
    final radius = BorderRadius.circular(AppRadius.sm);
    final url = DetailsFormat.text(unit.imagePath);
    final hasImage = url != null;

    final fallbackIcon = Icon(
      Icons.inventory_2_outlined,
      size: size * 0.56,
      color: selected ? colors.onPrimary : colors.textSecondary,
    );

    // The tile sits on a clean white surface so it stands out against the
    // card's muted fill and keeps transparent product images legible in both
    // themes; only the selected fallback glyph uses a primary-filled tile.
    final background = (selected && !hasImage) ? colors.primary : colors.surface;

    return Container(
      width: size,
      height: size,
      padding: hasImage ? EdgeInsets.all(AppSpacing.xs) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        border: Border.all(
          color: selected ? colors.primary : colors.border,
          width: selected ? 1.4 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: hasImage
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: (_, __) => fallbackIcon,
              errorWidget: (_, __, ___) => fallbackIcon,
            )
          : fallbackIcon,
    );
  }
}

/// Small primary-filled check shown on the selected card's first row.
class _SelectedCheck extends StatelessWidget {
  final AppPalette colors;

  const _SelectedCheck({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.check_rounded,
        size: 12.r,
        color: colors.onPrimary,
      ),
    );
  }
}
