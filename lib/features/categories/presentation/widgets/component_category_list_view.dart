import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/presentation/widgets/shop_group_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/categories/presentation/manager/category_state.dart';

class ComponentCategoryListView extends StatelessWidget {
  final CategoryCubit itemBloc;

  const ComponentCategoryListView({super.key, required this.itemBloc});

  @override
  Widget build(BuildContext context) {
    final currentLanguageCode = context.locale.languageCode;
    final height = MediaQuery.textScalerOf(context).scale(13) * 1.5 + 26;
    final barHeight = height < 44 ? 44.0 : height;

    if (itemBloc.state is GetSubCategoryLoading) {
      return SizedBox(
        height: barHeight,
        child: Skeletonizer(
          enabled: true,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
            itemCount: 6,
            itemBuilder:
                (context, index) => ShopGroupItem(
                  onTap: () {},
                  isSelected: false,
                  title: 'Category',
                ),
          ),
        ),
      );
    }

    if (itemBloc.subCategoryList.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: barHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
        itemCount: itemBloc.subCategoryList.length,
        itemBuilder: (context, index) {
          final item = itemBloc.subCategoryList[index];
          return ShopGroupItem(
            onTap: () {
              itemBloc.changeSelectedCategory(index: index);
              itemBloc.getItemsForSubCategory(subCategoryId: item.categoryId);
            },
            isSelected: itemBloc.subCategorySelect == index,
            title:
                currentLanguageCode == 'ar'
                    ? item.categoryArName
                    : item.categoryEnName,
          );
        },
      ),
    );
  }
}
