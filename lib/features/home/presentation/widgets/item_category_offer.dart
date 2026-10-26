import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';

class ItemsCategoryOffer extends StatelessWidget {
  final String categoryName;

  final List product;
  final dynamic isFavoriteMap;
  const ItemsCategoryOffer({
    super.key,
    required this.isFavoriteMap,
    required this.product,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = (isFavoriteMap as Map).cast<String, bool>();

    return Scaffold(
      appBar: AppTopBar(title: categoryName),
      body:
          product.isEmpty
              ? AppStateView.empty(
                icon: Icons.shopping_basket_outlined,
                title: 'no_products'.tr(),
              )
              : ProductGrid(products: product, isFavoriteMap: favorites),
    );
  }
}
