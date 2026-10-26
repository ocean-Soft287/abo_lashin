import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/home/data/model/banner_model.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_state.dart';
import 'package:abolashin/features/home/presentation/widgets/home_banner_carousel.dart';
import 'package:abolashin/features/home/presentation/widgets/home_categories_section.dart';
import 'package:abolashin/features/home/presentation/widgets/home_cta_cards.dart';
import 'package:abolashin/features/home/presentation/widgets/home_header.dart';
import 'package:abolashin/features/home/presentation/widgets/home_news_strip.dart';
import 'package:abolashin/features/home/presentation/widgets/home_product_section.dart';
import 'package:abolashin/features/home/presentation/widgets/item_category_offer.dart';
import 'package:abolashin/features/smart_shopping/presentation/screen/smart_shopping_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreenWi extends StatelessWidget {
  const HomeScreenWi({super.key});

  static double get _hPadding => 16.w;
  static Widget get _sectionGap => SizedBox(height: 10.h);

  void _reload(BuildContext context) {
    context.read<CategoryCubit>().getMainCategory();
    context.read<HomeCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.colors.primary,
      onRefresh: () async {
        context.read<CategoryCubit>().getMainCategory();
        await context.read<HomeCubit>().loadData();
      },
      // Only the page-level error/content switch listens here; every section
      // selects its own slice of the cubit, so one finished request no longer
      // rebuilds the whole page.
      child: BlocSelector<HomeCubit, HomeState, HomeErrorState?>(
        selector: (state) {
          final cubit = context.read<HomeCubit>();
          return state is HomeErrorState && !_hasData(cubit) ? state : null;
        },
        builder: (context, error) {
          if (error != null) {
            return ConnectivityRefresh(
              onReconnect: () => _reload(context),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const HomeHeader(),
                  SizedBox(height: 40.h),
                  AppStateView.failure(
                    failure: error.failure,
                    onRetry: () => _reload(context),
                  ),
                ],
              ),
            );
          }
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 24.h),
            children: [
              const HomeHeader(),
              SizedBox(height: 16.h),
              _Banners(select: (cubit) => cubit.bannerOneImageList),
              _NewsSection(horizontalPadding: _hPadding),
              _sectionGap,
              HomeCategoriesSection(horizontalPadding: _hPadding),
              _sectionGap,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _hPadding),
                child: HomeSmartShoppingCard(
                  onTap: () => context.pushScreen(const SmartShoppingScreen()),
                ),
              ),
              _sectionGap,
              _OffersCta(horizontalPadding: _hPadding),

              HomeProductSection(
                section: HomeSection.biggestDiscount,
                title: 'biggest_discount'.tr(),
                products: (cubit) => cubit.biggestDiscountList,
                favorites: (cubit) => cubit.itemsBiggestDiscountFavorite,
                retry: (cubit) => cubit.getBiggestDiscountProducts(),
                horizontalPadding: _hPadding,
              ),
              HomeProductSection(
                section: HomeSection.newProducts,
                title: 'new_arrival'.tr(),
                products: (cubit) => cubit.newProductList,
                favorites: (cubit) => cubit.itemsNewProductFavorite,
                retry: (cubit) => cubit.getNewProduct(),
                horizontalPadding: _hPadding,
              ),
              _Banners(
                select: (cubit) => cubit.bannerTwoImageList,
                trailingGap: true,
              ),
              HomeProductSection(
                section: HomeSection.bestSellers,
                title: 'bestsellers'.tr(),
                products: (cubit) => cubit.bestSellerList,
                favorites: (cubit) => cubit.itemsBestSellerFavorite,
                retry: (cubit) => cubit.getBestSellers(),
                horizontalPadding: _hPadding,
              ),
              HomeOffersSection(
                section: HomeSection.offersTwo,
                offers: (cubit) => cubit.offerTwoList,
                favorites: (cubit) => cubit.itemsOfferTwoFavorite,
                isVisible: (offer) => !offer.showOffer,
                horizontalPadding: _hPadding,
              ),
              HomeOffersSection(
                section: HomeSection.offers,
                offers: (cubit) => cubit.offerList,
                favorites: (cubit) => cubit.itemsOfferFavorite,
                // Offer1 rows were always all shown (the old check compared
                // this bool to 1); kept as-is.
                isVisible: (_) => true,
                horizontalPadding: _hPadding,
              ),
              _Banners(select: (cubit) => cubit.bannerThreeImageList),
            ],
          );
        },
      ),
    );
  }

  static bool _hasData(HomeCubit cubit) {
    return cubit.bannerOneImageList.isNotEmpty ||
        cubit.bannerTwoImageList.isNotEmpty ||
        cubit.bannerThreeImageList.isNotEmpty ||
        cubit.bestSellerList.isNotEmpty ||
        cubit.newProductList.isNotEmpty ||
        cubit.biggestDiscountList.isNotEmpty ||
        cubit.offerList.isNotEmpty ||
        cubit.offerTwoList.isNotEmpty;
  }
}

class _Banners extends StatelessWidget {
  final List<BannerModel> Function(HomeCubit cubit) select;
  final bool trailingGap;

  const _Banners({required this.select, this.trailingGap = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocSelector<HomeCubit, HomeState, List<BannerModel>>(
      selector: (_) => select(cubit),
      builder: (context, banners) {
        final carousel = HomeBannerCarousel(banners: banners);
        if (!trailingGap || banners.isEmpty) return carousel;
        return Column(children: [carousel, HomeScreenWi._sectionGap]);
      },
    );
  }
}

class _NewsSection extends StatelessWidget {
  final double horizontalPadding;

  const _NewsSection({required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocSelector<HomeCubit, HomeState, List>(
      selector: (_) => cubit.newsMarqueeList,
      builder: (context, _) {
        final news = cubit.newsMarqueeList;
        if (news.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            14.h,
            horizontalPadding,
            0,
          ),
          child: HomeNewsStrip(
            text: news.map((e) => e.newsText).join('      '),
          ),
        );
      },
    );
  }
}

class _OffersCta extends StatelessWidget {
  final double horizontalPadding;

  const _OffersCta({required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocSelector<HomeCubit, HomeState, List>(
      selector: (_) => cubit.biggestDiscountList,
      builder: (context, discounted) {
        if (discounted.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            10.h,
          ),
          child: HomeOffersCtaCard(
            onTap:
                () => context.pushScreen(
                  ItemsCategoryOffer(
                    product: cubit.biggestDiscountList,
                    isFavoriteMap: cubit.itemsBiggestDiscountFavorite,
                    categoryName: 'biggest_discount'.tr(),
                  ),
                ),
          ),
        );
      },
    );
  }
}
