import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/presentation/manager/category_state.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_state.dart';
import 'package:abolashin/features/smart_shopping/data/model/smart_shopping_goals.dart';
import 'package:abolashin/features/smart_shopping/presentation/widgets/smart_shopping_actions.dart';
import 'package:abolashin/features/smart_shopping/presentation/widgets/smart_suggestion_chip.dart';

/// "Try:" chips for the selected [goal]. A chip is shown only when the data
/// it opens exists, so none of them is a dead end.
class SmartGoalSuggestions extends StatelessWidget {
  final SmartGoal goal;

  const SmartGoalSuggestions({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xl,
        AppSpacing.xs,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'smart_try'.tr(),
            style: GoogleFonts.alexandria(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          switch (goal) {
            SmartGoal.stockStore => const _StockStoreChips(),
            SmartGoal.offers => const _OfferChips(),
            SmartGoal.restock => const _RestockChips(),
            _ => _CategoryChips(categoryIds: goal.categoryIds),
          },
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  final List<Widget> children;

  const _Chips(this.children);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: children,
    );
  }
}

class _StockStoreChips extends StatelessWidget {
  const _StockStoreChips();

  @override
  Widget build(BuildContext context) {
    final home = context.read<HomeCubit>();
    return BlocSelector<HomeCubit, HomeState, (List, List, bool)>(
      selector:
          (_) => (
            home.bestSellerList,
            home.newProductList,
            home.isSectionLoading(HomeSection.bestSellers),
          ),
      builder: (context, data) {
        final (bestSellers, newProducts, loadingBestSellers) = data;
        return _Chips([
          if (bestSellers.isNotEmpty)
            SmartSuggestionChip(
              label: 'smart_suggest_products'.tr(),
              icon: Icons.auto_awesome_rounded,
              onTap:
                  () => SmartShoppingActions.openProducts(
                    context,
                    title: 'bestsellers'.tr(),
                    products: home.bestSellerList,
                    favorites: home.itemsBestSellerFavorite,
                  ),
            )
          else if (loadingBestSellers)
            SmartSuggestionChip.loading(
              label: 'smart_loading_suggestions'.tr(),
            ),
          if (newProducts.isNotEmpty)
            SmartSuggestionChip(
              label: 'smart_new_arrivals'.tr(),
              icon: Icons.fiber_new_rounded,
              onTap:
                  () => SmartShoppingActions.openProducts(
                    context,
                    title: 'new_arrival'.tr(),
                    products: home.newProductList,
                    favorites: home.itemsNewProductFavorite,
                  ),
            ),
          SmartSuggestionChip(
            label: 'smart_browse_categories'.tr(),
            icon: Icons.grid_view_rounded,
            onTap: () => SmartShoppingActions.openHomeTab(context, 1),
          ),
          SmartSuggestionChip(
            label: 'smart_pick_category'.tr(),
            icon: Icons.category_outlined,
            onTap: () => SmartShoppingActions.pickCategory(context),
          ),
        ]);
      },
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<int> categoryIds;

  const _CategoryChips({required this.categoryIds});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen:
          (previous, current) =>
              current is GetMainCategoryLoading ||
              current is GetMainCategorySuccess ||
              current is GetMainCategoryError,
      builder: (context, state) {
        final cubit = context.read<CategoryCubit>();
        final all = cubit.mainCategoryList;
        if (all.isEmpty) {
          return _Chips([
            if (state is GetMainCategoryError)
              SmartSuggestionChip(
                label: 'retry'.tr(),
                icon: Icons.refresh_rounded,
                onTap: cubit.getMainCategory,
              )
            else
              SmartSuggestionChip.loading(label: 'loading'.tr()),
          ]);
        }
        final byId = {for (final c in all) c.categoryId: c};
        final matched = [
          for (final id in categoryIds)
            if (byId[id] != null) byId[id]!,
        ];
        final isArabic = context.locale.languageCode == 'ar';
        return _Chips([
          for (final category in matched)
            SmartSuggestionChip(
              label:
                  (isArabic
                      ? category.categoryArName
                      : category.categoryEnName) ??
                  '',
              onTap: () => SmartShoppingActions.openCategory(context, category),
            ),
          // The catalog may have been reorganised since these IDs were set.
          if (matched.isEmpty)
            SmartSuggestionChip(
              label: 'smart_browse_categories'.tr(),
              icon: Icons.grid_view_rounded,
              onTap: () => SmartShoppingActions.openHomeTab(context, 1),
            ),
        ]);
      },
    );
  }
}

class _OfferChips extends StatelessWidget {
  const _OfferChips();

  @override
  Widget build(BuildContext context) {
    final home = context.read<HomeCubit>();
    return BlocSelector<HomeCubit, HomeState, (List, List, List, bool)>(
      selector:
          (_) => (
            home.biggestDiscountList,
            home.offerTwoList,
            home.offerList,
            home.isSectionLoading(HomeSection.biggestDiscount) ||
                home.isSectionLoading(HomeSection.offers) ||
                home.isSectionLoading(HomeSection.offersTwo),
          ),
      builder: (context, data) {
        final (_, _, _, loading) = data;
        // Same visibility rules as the home page offer rows; each offer keeps
        // the favorites map of the list it came from.
        final offers = [
          for (final offer in home.offerTwoList)
            if (!offer.showOffer && offer.offerItems.isNotEmpty)
              (offer, home.itemsOfferTwoFavorite),
          for (final offer in home.offerList)
            if (offer.offerItems.isNotEmpty) (offer, home.itemsOfferFavorite),
        ];
        final chips = <Widget>[
          if (home.biggestDiscountList.isNotEmpty)
            SmartSuggestionChip(
              label: 'biggest_discount'.tr(),
              icon: Icons.percent_rounded,
              onTap:
                  () => SmartShoppingActions.openProducts(
                    context,
                    title: 'biggest_discount'.tr(),
                    products: home.biggestDiscountList,
                    favorites: home.itemsBiggestDiscountFavorite,
                  ),
            ),
          for (final (offer, favorites) in offers)
            SmartSuggestionChip(
              label: offer.offerName,
              icon: Icons.local_offer_outlined,
              onTap:
                  () => SmartShoppingActions.openProducts(
                    context,
                    title: offer.offerName,
                    products: offer.offerItems,
                    favorites: favorites,
                  ),
            ),
        ];
        if (chips.isEmpty) {
          return loading
              ? _Chips([SmartSuggestionChip.loading(label: 'loading'.tr())])
              : Text(
                'smart_no_offers'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 12.sp,
                  color: context.colors.textSecondary,
                ),
              );
        }
        return _Chips(chips);
      },
    );
  }
}

class _RestockChips extends StatelessWidget {
  const _RestockChips();

  @override
  Widget build(BuildContext context) {
    return _Chips([
      SmartSuggestionChip(
        label: 'smart_previous_orders'.tr(),
        icon: Icons.receipt_long_rounded,
        onTap: () => SmartShoppingActions.openPreviousOrders(context),
      ),
      SmartSuggestionChip(
        label: 'smart_favorites'.tr(),
        icon: Icons.favorite_border_rounded,
        onTap: () => SmartShoppingActions.openFavorites(context),
      ),
      SmartSuggestionChip(
        label: 'smart_open_cart'.tr(),
        icon: Icons.shopping_cart_outlined,
        onTap: () => SmartShoppingActions.openHomeTab(context, 2),
      ),
    ]);
  }
}
