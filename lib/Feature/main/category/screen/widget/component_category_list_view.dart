import 'package:abolashin/Feature/main/category/manager/category_cubit.dart';
import 'package:abolashin/Feature/main/category/screen/widget/shop_grpup_item.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../manager/category_state.dart';
class ComponentCategoryListView extends StatelessWidget {
  final CategoryCubit itemBloc;

  const ComponentCategoryListView({super.key, required this.itemBloc});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    String currentLanguageCode = currentLocale.languageCode;

    return
      ConditionalBuilder(
        condition: itemBloc.state is! GetSubCategoryLoading,
        builder: (context) {
          return SizedBox(
            height: 34.r,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: REdgeInsets.symmetric(horizontal: 16),
              itemCount: itemBloc.subCategoryList.length,
              itemBuilder: (context, index) {
                final item = itemBloc.subCategoryList[index];
                return itemBloc.subCategoryList.isEmpty
                    ? const SizedBox()
                    : ShopGroupItem(
                  onTap: () {
                    itemBloc.changeSelectedCategory(index: index);
                    itemBloc.getItemsForSubCategory( subCategoryId: item.categoryId);
                  },
                  isSelected: itemBloc.subCategorySelect == index,
                  title: currentLanguageCode == 'ar' ? item.categoryArName??'' : item.categoryEnName??'',
                );
              },
            ),
          );
        },
        fallback: (context) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 34.r,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: REdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  Skeletonizer(
                    enabled: true,
                     child: ShopGroupItem(
                      onTap: () {
                       // itemBloc.changeSelectedCategory(index: index);
                        //  itemBloc.getProductByCategory(item['CategoryId']);
                      },
                      isSelected: itemBloc.subCategorySelect == index,
                      title: 'Test   ',
                                       ),
                   );
                },
              ),
            ),
          ); // Show loading indicator
        },
      );
  }
}
