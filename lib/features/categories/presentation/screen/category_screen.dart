import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/presentation/manager/category_state.dart';
import 'package:abolashin/features/categories/presentation/screen/product_categories_page.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/search/presentation/screen/search_screen.dart';
import 'package:abolashin/features/categories/presentation/widgets/main_category_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const int _columns = 3;
  static double get _spacing => 12.w;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Column(
      children: [
        const _CategoriesHeader(),
        Expanded(
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              final cubit = BlocProvider.of<CategoryCubit>(context);
              final categories = cubit.mainCategoryList;

              if (categories.isEmpty && state is GetMainCategoryError) {
                return ConnectivityRefresh(
                  onReconnect: cubit.getMainCategory,
                  child: AppStateView.failure(
                    failure: state.failure,
                    onRetry: cubit.getMainCategory,
                  ),
                );
              }
              if (categories.isEmpty && state is GetMainCategorySuccess) {
                return AppStateView.empty(icon: Icons.grid_view_rounded);
              }
              final loading = categories.isEmpty;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final cellWidth =
                      (constraints.maxWidth -
                          AppSpacing.page * 2 -
                          _spacing * (_columns - 1)) /
                      _columns;
                  final extent =
                      cellWidth + 6 + MainCategoryCard.nameHeight(context) + 4;

                  return RefreshIndicator(
                    color: context.colors.primary,
                    onRefresh: cubit.getMainCategory,
                    child: Skeletonizer(
                      enabled: loading,
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.page,
                          AppSpacing.lg,
                          AppSpacing.page,
                          AppSpacing.xxl,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _columns,
                          crossAxisSpacing: _spacing,
                          mainAxisSpacing: _spacing,
                          mainAxisExtent: extent,
                        ),
                        itemCount: loading ? 12 : categories.length,
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
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.md,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: context.colors.primarySoft,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'categories'.tr(),
            style: GoogleFonts.alexandria(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Material(
            color: context.colors.surface,
            shape: StadiumBorder(
              side: BorderSide(color: context.colors.border),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => context.pushScreen(const SearchScreen()),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 50.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: context.colors.primary),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'search_products_hint'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.alexandria(
                            fontSize: 13.sp,
                            color: context.colors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
