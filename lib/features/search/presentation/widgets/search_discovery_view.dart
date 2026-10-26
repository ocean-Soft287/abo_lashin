import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/presentation/manager/category_state.dart';
import 'package:abolashin/features/categories/presentation/screen/product_categories_page.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_state.dart';
import 'package:abolashin/features/home/presentation/widgets/item_category_offer.dart';
import 'package:abolashin/features/products/presentation/screen/product_details_screen.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:abolashin/features/search/presentation/manager/search_cubit.dart';
import 'package:abolashin/features/search/presentation/widgets/search_chip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown before the user types: best sellers and offers already loaded for
/// the home page, then every catalog category.
class SearchDiscoveryView extends StatelessWidget {
  const SearchDiscoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.huge,
      ),
      children: [
        const _PopularSuggestions(),
        const _CategorySuggestions(),
        SizedBox(height: AppSpacing.xxl),
        const _SearchTip(),
      ],
    );
  }
}

class _PopularSuggestions extends StatelessWidget {
  const _PopularSuggestions();

  static const int _maxProducts = 6;

  @override
  Widget build(BuildContext context) {
    final home = context.read<HomeCubit>();
    // Rebuilds only when either list is replaced by a new response.
    return BlocSelector<HomeCubit, HomeState, (List, List)>(
      selector: (_) => (home.bestSellerList, home.biggestDiscountList),
      builder: (context, lists) {
        final (bestSellers, discounted) = lists;
        if (bestSellers.isEmpty && discounted.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.xxxl),
          child: _Group(
            icon: Icons.trending_up_rounded,
            title: 'bestsellers'.tr(),
            chips: [
              if (discounted.isNotEmpty)
                SearchChip(
                  label: 'biggest_discount'.tr(),
                  highlighted: true,
                  onTap:
                      () => context.pushScreen(
                        ItemsCategoryOffer(
                          product: home.biggestDiscountList,
                          isFavoriteMap: home.itemsBiggestDiscountFavorite,
                          categoryName: 'biggest_discount'.tr(),
                        ),
                      ),
                ),
              for (final product in bestSellers.take(_maxProducts))
                Builder(
                  builder: (context) {
                    final tile = ProductTileData.from(product);
                    return SearchChip(
                      label: tile.localizedName(context),
                      highlighted: true,
                      onTap:
                          () => context.pushScreen(
                            ProductDetailsScreen(
                              productId: tile.productId,
                              categoryId: tile.categoryId,
                            ),
                          ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CategorySuggestions extends StatelessWidget {
  const _CategorySuggestions();

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen:
          (previous, current) =>
              current is GetMainCategoryLoading ||
              current is GetMainCategorySuccess ||
              current is GetMainCategoryError,
      builder: (context, state) {
        final cubit = context.read<CategoryCubit>();
        final categories = cubit.mainCategoryList;
        if (categories.isEmpty && state is GetMainCategoryError) {
          return _Group(
            icon: Icons.grid_view_rounded,
            title: 'browse_categories'.tr(),
            chips: [
              ActionChip(
                avatar: Icon(Icons.refresh_rounded, size: 18.r),
                label: Text('retry'.tr()),
                onPressed: cubit.getMainCategory,
              ),
            ],
          );
        }
        final loading = categories.isEmpty;
        return Skeletonizer(
          enabled: loading,
          child: _Group(
            icon: Icons.grid_view_rounded,
            title: 'browse_categories'.tr(),
            chips: [
              if (loading)
                for (var i = 0; i < 8; i++)
                  SearchChip(label: 'x' * (6 + i % 3 * 4), onTap: () {})
              else
                for (final category in categories)
                  Builder(
                    builder: (context) {
                      final name =
                          (isArabic
                              ? category.categoryArName
                              : category.categoryEnName) ??
                          category.categoryArName ??
                          '';
                      return SearchChip(
                        label: name,
                        onTap:
                            () => context.pushScreen(
                              ProductCategoriesPage(
                                categoryId: category.categoryId,
                                categoryName: name,
                              ),
                            ),
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _Group extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> chips;

  const _Group({required this.icon, required this.title, required this.chips});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, color: colors.primary, size: 24.r),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.alexandria(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: chips,
        ),
      ],
    );
  }
}

/// What the search matches, so users know they can type a product code.
class _SearchTip extends StatelessWidget {
  const _SearchTip();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.manage_search_rounded, color: colors.primary),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'search_tip_title'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'search_tip_message'.tr(
                    args: ['${SearchCubit.minQueryLength}'],
                  ),
                  style: GoogleFonts.alexandria(
                    fontSize: 12.5.sp,
                    height: 1.5,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
