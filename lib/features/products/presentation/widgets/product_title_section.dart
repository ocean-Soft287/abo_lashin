import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/widgets/product_details_sections.dart';

/// Product code tab, name, attribute chips and the collapsible description.
class ProductTitleSection extends StatefulWidget {
  final ProductDetailsModel product;

  const ProductTitleSection({super.key, required this.product});

  @override
  State<ProductTitleSection> createState() => _ProductTitleSectionState();
}

class _ProductTitleSectionState extends State<ProductTitleSection> {
  bool _showDescription = true;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final colors = context.colors;
    final isArabic = context.locale.languageCode == 'ar';
    String? loc(dynamic ar, dynamic en) =>
        DetailsFormat.localized(isArabic, ar, en);

    final name = loc(product.productArName, product.productEnName) ?? '';
    final code = DetailsFormat.text(product.productCode);
    final category = loc(product.categoryArName, product.categoryEnName);
    final brand = loc(product.brandArName, product.brandEnName);
    final description = DetailsFormat.text(product.specifications);

    final chips = <Widget>[
      if (category != null)
        _AttributeChip(
          icon: Icons.category_outlined,
          label: category,
          background: colors.secondarySoft,
          foreground: colors.textPrimary,
        ),
      if (brand != null)
        _AttributeChip(
          icon: Icons.verified_outlined,
          label: brand,
          background: colors.primarySoft,
          foreground: colors.primary,
        ),
      if (product.isWeighingProduct == true)
        _AttributeChip(
          icon: Icons.scale_outlined,
          label: 'sold_by_weight'.tr(),
          background: colors.primarySoft,
          foreground: colors.primary,
        ),
      if (description != null)
        _AttributeChip(
          icon: Icons.notes_rounded,
          label: 'description'.tr(),
          trailing:
              _showDescription
                  ? Icons.arrow_drop_up_rounded
                  : Icons.arrow_drop_down_rounded,
          background: colors.successSoft,
          foreground: colors.success,
          onTap: () => setState(() => _showDescription = !_showDescription),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (code != null) _CodeTab(code: code),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: GoogleFonts.alexandria(
                  fontSize:17.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              if (chips.isNotEmpty) ...[
                SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: chips,
                ),
              ],
              if (description != null)
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: AlignmentDirectional.topStart,
                  child:
                      _showDescription
                          ? Container(
                            margin: EdgeInsets.only(top: AppSpacing.lg),
                            padding: EdgeInsets.all(AppSpacing.xl),
                            decoration: BoxDecoration(
                              color: colors.surfaceMuted,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Text(
                              description,
                              style: GoogleFonts.alexandria(
                                fontSize: 14.sp,
                                height: 1.8,
                                color: colors.textPrimary,
                              ),
                            ),
                          )
                          : const SizedBox(width: double.infinity),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "SKU : 1006" tab flush with the screen edge, open on its bottom and
/// outer side like the reference.
class _CodeTab extends StatelessWidget {
  final String code;

  const _CodeTab({required this.code});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ClipRect(
        child: Transform.translate(
          // Push the outer and bottom borders just out of the clip.
          offset: Offset(rtl ? -1.5 : 1.5, 1.5),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: colors.border, width: 1.2),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Text(
              'sku_label'.tr(args: [code]),
              textDirection: TextDirection.ltr,
              style: GoogleFonts.alexandria(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AttributeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final IconData? trailing;
  final VoidCallback? onTap;

  const _AttributeChip({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.pill);
    return Material(
      color: background,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 40.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 17.r, color: foreground),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexandria(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                    ),
                  ),
                ),
                if (trailing != null)
                  Icon(trailing, size: 22.r, color: foreground),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
