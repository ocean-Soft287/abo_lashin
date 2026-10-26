import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/cart/presentation/widgets/counter_box_component.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_cubit.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_state.dart';
import 'package:abolashin/features/products/presentation/screen/product_details_screen.dart';
import 'package:abolashin/features/home/data/model/offer_model.dart';
import 'package:abolashin/features/products/data/model/product_model.dart';

class ProductTileData {
  final int productId;
  final String? categoryId;
  final String barCode;
  final String nameAr;
  final String nameEn;
  final String displayNameAr;
  final String displayNameEn;
  final String? unitAr;
  final String? unitEn;
  final String image;
  final double price;
  final double priceAfterDiscount;
  final num stockQuantity;
  final num customerQuantity;

  const ProductTileData({
    required this.productId,
    required this.categoryId,
    required this.barCode,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.price,
    required this.priceAfterDiscount,
    required this.stockQuantity,
    required this.customerQuantity,
    String? displayNameAr,
    String? displayNameEn,
    this.unitAr,
    this.unitEn,
  }) : displayNameAr = displayNameAr ?? nameAr,
       displayNameEn = displayNameEn ?? nameEn;

  static double _safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.trim()) ?? 0.0;
    }
    return 0.0;
  }

  static num _safeNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  static String? _nonEmpty(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  static String _stripUnit(String name, String? unit) {
    if (unit == null) return name;

    final suffix = ' ($unit)';

    return name.endsWith(suffix)
        ? name.substring(0, name.length - suffix.length)
        : name;
  }

  factory ProductTileData.from(dynamic product) {
    if (product is ProductTileData) return product;

    if (product is ProductModel) {
      // The unit the model appended to the name as " (unit)".
      final appendedAr =
          _nonEmpty(product.defaultUnitArName) ?? _nonEmpty(product.unitArName);

      final appendedEn =
          _nonEmpty(product.defaultUnitEnName) ?? _nonEmpty(product.unitEnName);

      // Prefer the unit the price is for; older endpoints only send the
      // default unit.
      final orderAr = _nonEmpty(product.orderUnitArName);
      final orderEn = _nonEmpty(product.orderUnitEnName);
      final hasOrderUnit = orderAr != null || orderEn != null;

      final nameAr = product.productArName;
      final nameEn = product.productEnName;

      return ProductTileData(
        productId: product.productId,
        categoryId: product.categoryId,
        barCode: product.barCode,
        nameAr: nameAr,
        nameEn: nameEn,
        displayNameAr: _stripUnit(nameAr, appendedAr),
        displayNameEn: _stripUnit(nameEn, appendedEn),
        unitAr: hasOrderUnit ? orderAr ?? orderEn : appendedAr,
        unitEn: hasOrderUnit ? orderEn ?? orderAr : appendedEn,
        image: product.productImage ?? '',
        price: _safeDouble(product.price),
        priceAfterDiscount: _safeDouble(product.priceAfterDiscount),
        stockQuantity: _safeNum(product.stockQuantity),
        customerQuantity: _safeNum(product.customerQuantity),
      );
    }

    if (product is OfferItem) {
      final nameAr = product.productArName ?? product.productEnName ?? '';
      final nameEn = product.productEnName ?? product.productArName ?? '';

      return ProductTileData(
        productId: product.productId,
        categoryId: product.categoryId,
        barCode: product.barCode ?? '',
        nameAr: nameAr,
        nameEn: nameEn,
        unitAr: product.orderUnitArName ?? product.orderUnitEnName,
        unitEn: product.orderUnitEnName ?? product.orderUnitArName,
        image: product.productImage ?? '',
        price: _safeDouble(product.price),
        priceAfterDiscount: _safeDouble(product.priceAfterDiscount),
        stockQuantity: _safeNum(product.stockQuantity),
        customerQuantity: _safeNum(product.customerQuantity),
      );
    }

    throw ArgumentError.value(
      product.runtimeType,
      'product',
      'Unsupported product type',
    );
  }

  bool get hasDiscount => priceAfterDiscount < price;

  int? get discountPercent {
    if (price <= 0 || priceAfterDiscount >= price) return null;

    final percent = ((price - priceAfterDiscount) / price * 100).round();

    return percent > 0 ? percent : null;
  }

  bool _isArabic(BuildContext context) => context.locale.languageCode == 'ar';

  String localizedName(BuildContext context) =>
      _isArabic(context) ? displayNameAr : displayNameEn;

  /// The unit in the current language, falling back to the other one;
  /// null (label hidden) when neither is set or both are blank.
  String? localizedUnit(BuildContext context) {
    final ar = _nonEmpty(unitAr);
    final en = _nonEmpty(unitEn);
    return _isArabic(context) ? (ar ?? en) : (en ?? ar);
  }
}

class ProductTile extends StatelessWidget {
  final ProductTileData product;
  final Map<String, bool> isFavoriteMap;

  /// Hero tag for the product image. The builder makes it unique per card so
  /// the same product shown in several rows never collides, and the tapped
  /// card forwards this exact tag to the details screen so the image flies.
  /// Null disables the Hero (used where no transition source is wanted).
  final String? heroTag;

  const ProductTile({
    super.key,
    required this.product,
    required this.isFavoriteMap,
    this.heroTag,
  });

  static double get _padding => 10.r;
  static const double _nameLineHeight = 1.35;
  static double get _buttonHeight => 40.h;

  static double _nameFontSize() => 12.5.sp;
  static double _priceFontSize() => 15.sp;
  static double _chipFontSize() => 11.sp;

  static double infoHeight(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final name = scaler.scale(_nameFontSize()) * _nameLineHeight * 2;
    final chip = scaler.scale(_chipFontSize()) * 1.45 + 6.h;
    final price = scaler.scale(_priceFontSize()) * 1.4;

    return _padding +
        name +
        6.h +
        chip +
        6.h +
        price +
        8.h +
        _buttonHeight +
        _padding +
        2;
  }

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final unit = product.localizedUnit(context);

    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.pushScreen(
            ProductDetailsScreen(
              productId: product.productId,
              categoryId: product.categoryId,
              heroTag: heroTag,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 4.h),
                      // Only the image flies; the badge and favorite button are
                      // siblings outside the Hero so they stay put.
                      child:
                          heroTag == null
                              ? ProductTileImage(url: product.image)
                              : Hero(
                                tag: heroTag!,
                                child: ProductTileImage(url: product.image),
                              ),
                    ),
                  ),
                  if (product.hasDiscount)
                    PositionedDirectional(
                      top: 0,
                      start: 0,
                      child: DiscountRibbon(percent: product.discountPercent),
                    ),
                  PositionedDirectional(
                    top: 4.h,
                    end: 4.w,
                    child: _FavoriteButton(
                      barCode: product.barCode,
                      productId: product.productId,
                      isFavoriteMap: isFavoriteMap,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: scaler.scale(_nameFontSize()) * _nameLineHeight * 2,
                    child: Text(
                      product.localizedName(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.alexandria(
                        fontSize: _nameFontSize(),
                        height: _nameLineHeight,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  SizedBox(
                    height: scaler.scale(_chipFontSize()) * 1.45 + 6.h,
                    child:
                        unit == null
                            ? null
                            : Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: InfoChip(
                                icon: Icons.scale_outlined,
                                label: unit,
                              ),
                            ),
                  ),
                  SizedBox(height: 6.h),
                  SizedBox(
                    height: scaler.scale(_priceFontSize()) * 1.4,
                    child: _PriceRow(product: product),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: _buttonHeight,
                    child: CounterBox(
                      filled: true,
                      wide: true,
                      productId: product.productId,
                      nameAr: product.nameAr,
                      nameEn: product.nameEn,
                      priceBeforeDiscount: product.price,
                      priceAfterDiscount: product.priceAfterDiscount,
                      image: product.image,
                      customerQuantity: product.customerQuantity,
                      stockQuantity: product.stockQuantity,
                      barcode: product.barCode,
                      customerquntatiy: product.customerQuantity,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductTileImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const ProductTileImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: context.colors.textHint,
        size: 36.r,
      ),
    );

    if (url.trim().isEmpty) return fallback;

    final dpr = MediaQuery.devicePixelRatioOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int? cacheWidth =
            width.isFinite ? (width * dpr).round().clamp(64, 1080) : null;

        return CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          memCacheWidth: cacheWidth,
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder:
              (context, url) => Center(
                child: Icon(
                  Icons.shopping_basket_outlined,
                  color: context.colors.skeletonBase,
                  size: 36.r,
                ),
              ),
          errorWidget: (context, url, error) => fallback,
        );
      },
    );
  }
}

class DiscountRibbon extends StatelessWidget {
  final int? percent;

  const DiscountRibbon({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    // "خصم 15%" / "15% off" from the shared discount key; the generic
    // "special offer" label stays as the fallback when no percent is known.
    final label =
        percent == null
            ? 'special_offer'.tr()
            : 'unit_discount'.tr(args: ['$percent']);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: context.colors.danger,
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(AppRadius.md),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.alexandria(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: context.colors.onDanger,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final ProductTileData product;

  const _PriceRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final currency = 'currency'.tr();

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: formatPrice(product.priceAfterDiscount),
                  style: GoogleFonts.alexandria(
                    fontSize: ProductTile._priceFontSize(),
                    fontWeight: FontWeight.w800,
                    color: context.colors.primary,
                  ),
                ),
                TextSpan(
                  text: currency,
                  style: GoogleFonts.alexandria(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            maxLines: 1,
          ),
          if (product.hasDiscount) ...[
            SizedBox(width: 6.w),
            Text(
              formatPrice(product.price),
              maxLines: 1,
              style: GoogleFonts.alexandria(
                fontSize: 11.sp,
                color: context.colors.textHint,
                decoration: TextDecoration.lineThrough,
                decorationColor: context.colors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final String barCode;
  final int productId;
  final Map<String, bool> isFavoriteMap;

  const _FavoriteButton({
    required this.barCode,
    required this.productId,
    required this.isFavoriteMap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        final isFavorite = isFavoriteMap[barCode] ?? false;

        return IconButton(
          tooltip: 'favorites'.tr(),
          style: IconButton.styleFrom(
            backgroundColor: context.colors.surface.withValues(alpha: 0.92),
            minimumSize: Size(40.w, 40.h),
          ),
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 21.r,
            color:
                isFavorite
                    ? context.colors.danger
                    : context.colors.textSecondary,
          ),
          onPressed: () async {
            if (!await context.ensureSignedIn()) return;
            if (!context.mounted) return;
            BlocProvider.of<FavoriteCubit>(context).addFavorite(
              barcode: barCode,
              favorite: isFavoriteMap,
              productId: productId,
            );
          },
        );
      },
    );
  }
}

class ProductGrid extends StatelessWidget {
  final List products;
  final Map<String, bool> isFavoriteMap;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const ProductGrid({
    super.key,
    required this.products,
    required this.isFavoriteMap,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
  });

  static double get spacing => 12.w;

  static double cellExtent(
    BuildContext context,
    double width, {
    int crossAxisCount = 2,
  }) {
    final cellWidth = (width - spacing * (crossAxisCount - 1)) / crossAxisCount;

    return cellWidth * 0.8 + ProductTile.infoHeight(context);
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        this.padding ??
        EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.xxl,
        );
    final resolved = padding.resolve(Directionality.of(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            (constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width) -
            resolved.horizontal;

        return GridView.builder(
          controller: controller,
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: cellExtent(context, width),
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final data = ProductTileData.from(products[index]);
            return ProductTile(
              product: data,
              isFavoriteMap: isFavoriteMap,
              // Index is unique within a grid route, so the tag never collides
              // even if the same product id appears twice.
              heroTag: 'product-image-${data.productId}-grid-$index',
            );
          },
        );
      },
    );
  }
}
