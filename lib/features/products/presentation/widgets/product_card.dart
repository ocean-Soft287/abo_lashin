import 'package:abolashin/core/route/navigation.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/features/home/presentation/widgets/home_section_header.dart';
import 'package:abolashin/features/home/presentation/widgets/item_category_offer.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final List product;
  final String categoryName;

  final dynamic isFavoriteMap;

  final double horizontalPadding;

  final bool loading;

  const ProductCard({
    super.key,
    required this.product,
    required this.categoryName,
    required this.isFavoriteMap,
    this.horizontalPadding = 0,
    this.loading = false,
  });

  static double get _spacing => 10.w;

  static double cardWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ((width - 16 - _spacing * 2) / 2.2).clamp(148.0, 220.0);
  }

  @override
  Widget build(BuildContext context) {
    final width = cardWidth(context);
    final height = width * 0.8 + ProductTile.infoHeight(context);
    final favorites = (isFavoriteMap as Map).cast<String, bool>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: HomeSectionHeader(
            title: categoryName,
            onSeeMore:
                loading
                    ? null
                    : () {
                      context.pushScreen(
                        ItemsCategoryOffer(
                          isFavoriteMap: isFavoriteMap,
                          categoryName: categoryName,
                          product: product,
                        ),
                      );
                    },
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: height,
          child:
              loading
                  ? ProductRowSkeleton(
                    cardWidth: width,
                    horizontalPadding: horizontalPadding,
                  )
                  : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    itemCount: product.length,
                    itemBuilder: (context, index) {
                      final data = ProductTileData.from(product[index]);
                      return SizedBox(
                        width: width,
                        child: ProductTile(
                          product: data,
                          isFavoriteMap: favorites,
                          // Section name + index keep the tag unique even when
                          // the same product appears in more than one row.
                          heroTag:
                              'product-image-${data.productId}-$categoryName-$index',
                        ),
                      );
                    },
                    separatorBuilder:
                        (context, index) => SizedBox(width: _spacing),
                  ),
        ),
      ],
    );
  }
}

class ProductRowSkeleton extends StatelessWidget {
  final double cardWidth;
  final double horizontalPadding;

  const ProductRowSkeleton({
    super.key,
    required this.cardWidth,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: 3,
        itemBuilder:
            (context, index) => Container(
              width: cardWidth,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: Bone(width: double.infinity)),
                  SizedBox(height: 10.h),
                  const Bone.text(words: 3),
                  SizedBox(height: 6.h),
                  const Bone.text(words: 1),
                ],
              ),
            ),
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
      ),
    );
  }
}
