import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/products/presentation/widgets/product_details_sections.dart';

/// Live countdown to the offer's end date (`ToDate`), designed to sit inside
/// the navy price card and so painted in the card's on-brand colour. It shows
/// the remaining days, hours and minutes.
///
/// The end date only *feeds the clock* — it never decides whether the discount
/// is shown; the price card does that from the prices alone. This widget simply
/// has nothing to count when the date is missing, unset (the SQL default the
/// shared parser already drops) or already past, so it renders nothing in those
/// cases and the card keeps its plain height.
class ProductOfferCountdown extends StatefulWidget {
  final String? toDate;

  const ProductOfferCountdown({super.key, required this.toDate});

  @override
  State<ProductOfferCountdown> createState() => _ProductOfferCountdownState();
}

class _ProductOfferCountdownState extends State<ProductOfferCountdown> {
  Timer? _timer;
  DateTime? _end;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant ProductOfferCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.toDate != widget.toDate) _start();
  }

  void _start() {
    _timer?.cancel();
    _end = DetailsFormat.parseDate(widget.toDate);
    _tick();
    if (_end != null && _remaining > Duration.zero) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  void _tick() {
    final end = _end;
    final left = end == null ? Duration.zero : end.difference(DateTime.now());
    final clamped = left.isNegative ? Duration.zero : left;
    if (clamped == Duration.zero) _timer?.cancel();
    if (!mounted) return;
    setState(() => _remaining = clamped);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// `<d> <h> <m>` with localized unit suffixes; the days group is dropped
  /// once under a day remains so the row stays compact.
  String _format(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final parts = <String>[
      if (days > 0) '$days${'cd_days_short'.tr()}',
      '$hours${'cd_hours_short'.tr()}',
      '$minutes${'cd_minutes_short'.tr()}',
    ];
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (_end == null || _remaining <= Duration.zero) {
      return const SizedBox.shrink();
    }
    final colors = context.colors;
    final onBrand = colors.onBrand;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: onBrand.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Icon(Icons.timer_outlined, size: 15.r, color: onBrand),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'offer_ends_in'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.alexandria(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: onBrand,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            // The clock reads left-to-right in both languages.
            Text(
              _format(_remaining),
              textDirection: TextDirection.ltr,
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: onBrand,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
