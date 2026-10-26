import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/presentation/manager/category_state.dart';
import 'package:abolashin/features/categories/presentation/screen/product_categories_page.dart';
import 'package:abolashin/features/categories/presentation/widgets/main_category_card.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/home/presentation/widgets/home_section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCategoriesSection extends StatelessWidget {
  final double horizontalPadding;

  const HomeCategoriesSection({super.key, required this.horizontalPadding});

  static double get _spacing => 12.w;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final tileWidth = (MediaQuery.sizeOf(context).width / 4.1).clamp(
      72.0,
      110.0,
    );
    final rowHeight = tileWidth + 6 + MainCategoryCard.nameHeight(context);

    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen:
          (previous, current) =>
              current is GetMainCategoryLoading ||
              current is GetMainCategorySuccess ||
              current is GetMainCategoryError,
      builder: (context, state) {
        final categories = context.read<CategoryCubit>().mainCategoryList;
        final settled =
            state is GetMainCategoryError || state is GetMainCategorySuccess;
        if (categories.isEmpty && settled) return const SizedBox.shrink();
        final loading = categories.isEmpty;
        final count = loading ? 8 : categories.length;
        final rows = count > 4 ? 2 : 1;
        final height = rowHeight * rows + _spacing * (rows - 1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: HomeSectionHeader(
                title: 'shop_by_categories'.tr(),
                onSeeMore:
                    () => BlocProvider.of<HomeCubit>(
                      context,
                    ).changeSelectIndexBottom(index: 1),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: height,
              child: Skeletonizer(
                enabled: loading,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  physics:
                      loading ? const NeverScrollableScrollPhysics() : null,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rows,
                    mainAxisSpacing: _spacing,
                    crossAxisSpacing: _spacing,
                    mainAxisExtent: tileWidth,
                  ),
                  itemCount: count,
                  itemBuilder: (context, index) {
                    if (loading) {
                      return const MainCategoryCard(
                        categoryName: '         ',
                        imagePath: '',
                      );
                    }
                    final category = categories[index];
                    final name =
                        isArabic
                            ? category.categoryArName.toString()
                            : category.categoryEnName.toString();
                    return InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      onTap: () {
                        context.pushScreen(
                          ProductCategoriesPage(
                            categoryId: category.categoryId,
                            categoryName: name,
                          ),
                        );
                      },
                      child: MainCategoryCard(
                        categoryName: name,
                        imagePath: category.categoryImage.toString(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
