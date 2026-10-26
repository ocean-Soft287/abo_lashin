import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/manager/product_details_cubit.dart';
import 'package:abolashin/features/products/presentation/manager/product_details_state.dart';
import 'package:abolashin/features/products/presentation/widgets/product_details_extras.dart';
import 'package:abolashin/features/products/presentation/widgets/product_details_sections.dart';
import 'package:abolashin/features/products/presentation/widgets/product_details_top_bar.dart';
import 'package:abolashin/features/products/presentation/widgets/product_gallery.dart';
import 'package:abolashin/features/products/presentation/widgets/product_price_card.dart';
import 'package:abolashin/features/products/presentation/widgets/product_quantity_stepper.dart';
import 'package:abolashin/features/products/presentation/widgets/product_title_section.dart';
import 'package:abolashin/features/products/presentation/widgets/product_unit_selector.dart';
import 'package:abolashin/features/products/presentation/widgets/product_units.dart';

class ProductDetailsScreen extends StatelessWidget {
  final dynamic productId;
  final dynamic categoryId;

  /// Hero tag forwarded by the tapped product card so its image flies into
  /// the gallery; null when opened without a transition source (deep links,
  /// search suggestions), in which case the gallery shows no Hero.
  final String? heroTag;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.categoryId,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ProductDetailsCubit()..getProductDetails(productId: productId),
      child: _ProductDetailsView(
        productId: productId,
        categoryId: categoryId,
        heroTag: heroTag,
      ),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final dynamic productId;
  final dynamic categoryId;
  final String? heroTag;

  const _ProductDetailsView({
    required this.productId,
    required this.categoryId,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (previous, current) => current is! ChangeSelectedUnit,
      builder: (context, state) {
        final cubit = context.read<ProductDetailsCubit>();
        final loaded =
            state is! GetProductDetailsLoading &&
            cubit.productDetailsList.isNotEmpty;
        final product = loaded ? cubit.productDetailsList.first : null;

        return Scaffold(
          backgroundColor: context.colors.surface,
          appBar: ProductDetailsTopBar(product: product),
          body: CustomScrollView(
            slivers:
                product != null
                    ? _productSlivers(product)
                    : _statusSlivers(context, state, cubit),
          ),
        );
      },
    );
  }

  /// Same order as the reference: photo, code/name/chips/description,
  /// price with quantity, units, then related products.
  List<Widget> _productSlivers(ProductDetailsModel product) {
    final units = product.productUnitImages ?? const <UnitsModel>[];
    Widget box(Widget child) =>
        SliverToBoxAdapter(child: DetailsConstrained(child: child));
    final gap = SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl));
    return [
      box(
        ProductGallery(
          images: _images(product, units),
          heroTag: heroTag,
          badge: units.isEmpty ? null : _GalleryDiscountBadge(units: units),
        ),
      ),
      box(ProductTitleSection(product: product)),
      gap,
      box(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child:
              units.isEmpty
                  ? _UnorderableProduct(product: product)
                  : _PurchaseSection(
                    product: product,
                    units: units,
                    productId: productId,
                  ),
        ),
      ),
      gap,
      box(SimilarProductsSection(categoryId: categoryId)),
      SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
    ];
  }

  List<Widget> _statusSlivers(
    BuildContext context,
    ProductDetailsState state,
    ProductDetailsCubit cubit,
  ) {
    if (state is GetProductDetailsError) {
      void retry() => cubit.getProductDetails(productId: productId);
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ConnectivityRefresh(
            onReconnect: retry,
            child: AppStateView.failure(failure: state.failure, onRetry: retry),
          ),
        ),
      ];
    }
    if (state is GetProductDetailsSuccess) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: AppStateView.empty(
            title: 'product_unavailable'.tr(),
            icon: Icons.remove_shopping_cart_outlined,
          ),
        ),
      ];
    }
    return const [
      SliverToBoxAdapter(
        child: DetailsConstrained(child: ProductDetailsSkeleton()),
      ),
    ];
  }

  static List<String> _images(
    ProductDetailsModel product,
    List<UnitsModel> units,
  ) {
    final images = <String>[];
    for (final url in [
      DetailsFormat.text(product.productcImage),
      for (final unit in units) DetailsFormat.text(unit.imagePath),
    ]) {
      if (url != null && !images.contains(url)) images.add(url);
    }
    return images;
  }
}

/// Selected unit price with its quantity, then the unit picker; only this
/// part rebuilds when another unit is selected.
class _PurchaseSection extends StatelessWidget {
  final ProductDetailsModel product;
  final List<UnitsModel> units;
  final dynamic productId;

  const _PurchaseSection({
    required this.product,
    required this.units,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailsCubit>();
    return BlocSelector<ProductDetailsCubit, ProductDetailsState, int>(
      selector: (_) => cubit.selectedIndexFor(units.length),
      builder: (context, selected) {
        final unit = units[selected];
        // Single source of truth for the discount; null when the selected
        // unit has no valid discount, so no badge/strikethrough is shown.
        final discount = ProductUnits.discountPercent(unit);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductPriceCard(
              price: unit.priceAfterDiscount,
              originalPrice: discount == null ? null : unit.price,
              discountPercent: discount,
              // Only feeds the in-card countdown; visibility is price-driven.
              toDate: product.toDate,
              stepper: ProductQuantityStepper(
                key: ValueKey('stepper-${unit.barcode}-$selected'),
                unit: unit,
                productId: int.tryParse('$productId') ?? unit.productId,
                productArName: '${product.productArName}',
                productEnName: '${product.productEnName}',
                image: product.productcImage.toString(),
              ),
            ),
            SizedBox(height: AppSpacing.xxxl),
            ProductUnitSelector(
              units: units,
              selectedIndex: selected,
              onSelect: (index) => cubit.changeSelectedUnit(index: index),
            ),
          ],
        );
      },
    );
  }
}


/// Discount badge overlaid on the gallery image. Tracks the selected unit —
/// not the gallery, so the image and its Hero never rebuild — and shows only
/// when that unit has a valid discount per the existing pricing rule.
class _GalleryDiscountBadge extends StatelessWidget {
  final List<UnitsModel> units;

  const _GalleryDiscountBadge({required this.units});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailsCubit>();
    return BlocSelector<ProductDetailsCubit, ProductDetailsState, int>(
      selector: (_) => cubit.selectedIndexFor(units.length),
      builder: (context, selected) {
        final discount = ProductUnits.discountPercent(units[selected]);
        if (discount == null) return const SizedBox.shrink();
        return GalleryDiscountBadge(percent: discount);
      },
    );
  }
}

class _UnorderableProduct extends StatelessWidget {
  final ProductDetailsModel product;

  const _UnorderableProduct({required this.product});

  @override
  Widget build(BuildContext context) {
    final price = DetailsFormat.number(product.priceAfterDiscount) ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (price > 0) ...[
          ProductPriceCard(price: price),
          SizedBox(height: AppSpacing.md),
        ],
        const ProductUnavailableNotice(),
      ],
    );
  }
}
