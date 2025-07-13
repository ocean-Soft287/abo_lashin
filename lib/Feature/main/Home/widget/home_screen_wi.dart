import 'package:abolashin/Feature/main/Add%20Order/manager/add_order_cubit.dart';
import 'package:abolashin/Feature/main/Home/widget/porduct_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:marquee/marquee.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constans/app_assets.dart';
import '../../../../core/constans/app_colors.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/navigation.dart';
import '../../Add Order/manager/add_order_state.dart';
import '../../Search/screen/search_screen.dart';
import '../../cart/screen/manager/cart_cubit.dart';
import '../../cart/screen/manager/chat_state.dart';
import '../../category/manager/category_cubit.dart';
import '../../category/manager/category_state.dart';
import '../../category/screen/main_category_card.dart';
import '../../category/screen/product_categories_page.dart';
import '../../menu/Saved _Addresses/saved_addresses.dart';
import '../manager/home_cubit.dart';
import '../manager/home_state.dart';
import 'banner_product_screen.dart';

class HomeScreenWi extends StatelessWidget {
  const HomeScreenWi({super.key});

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
    final currentLocale = context.locale;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: InkWell(
                        onTap: () {
                          navigato(context, const SavedAddressesScreen());
                        },
                        child: Column(
                          children: [
                            BlocBuilder<AddOrderCubit, AddOrderState>(
                              builder: (context, state) {
                                return ConditionalBuilder(
                                  condition:
                                      BlocProvider.of<AddOrderCubit>(
                                        context,
                                      ).allAddressList.isNotEmpty,
                                  builder: (context) {
                                    final address =
                                        BlocProvider.of<AddOrderCubit>(
                                          context,
                                        ).allAddressList[context
                                            .read<AddOrderCubit>()
                                            .selectAddress];

                                    return Text(
                                      '${address.address ?? ""} - ${address.addressNotes ?? ""}',
                                      style: GoogleFonts.alexandria(
                                        textStyle: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.mainAppColor,
                                        ),
                                      ),
                                    );
                                  },
                                  fallback:
                                      (context) => Text(
                                        " ",
                                        style: GoogleFonts.alexandria(
                                          textStyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.mainAppColor,
                                          ),
                                        ),
                                      ),
                                );
                              },
                            ),

                            Text(
                              'your_address'.tr(),
                              style: GoogleFonts.alexandria(
                                textStyle: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff5C5C5C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F1F1),
                        borderRadius: BorderRadius.circular(30),
                      ),
               ///
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              BlocProvider.of<HomeCubit>(
                                context,
                              ).changeSelectIndexBottom(index: 2);
                            },
                            child: SvgPicture.asset(AppAssets.cartNoEmptyIcon),
                          ),
                          BlocBuilder<CartCubit, CartState>(
                            builder: (context, state) {
                              final cubit= context.watch<CartCubit>();
                              return Text(
                                '${cubit.cartItems.isNotEmpty ?cubit.cartItems.length: 0}',
                                style: GoogleFonts.alexandria(
                                  textStyle: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.mainAppColor,
                                  ),
                                ),
                              );
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () {
                navigato(context, const SearchScreen());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'search'.tr(),
                      style: GoogleFonts.alexandria(
                        textStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff6A6A6A),
                        ),
                      ),
                    ),
                    SvgPicture.asset(AppAssets.searchIcon),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (BlocProvider.of<HomeCubit>(
                    context,
                  ).bannerOneImageList.isEmpty) {
                    return Skeletonizer(
                      enabled: true,
                      child: Image.asset(
                        AppAssets.searchIcon,
                        height: 100.h,
                        fit: BoxFit.fill,
                      ),
                    );
                  }

                  return Visibility(
                    visible:
                        BlocProvider.of<HomeCubit>(
                          context,
                        ).bannerOneImageList[0].showGroup !=
                        0,
                    child: CarouselSlider.builder(
                      itemCount:
                          BlocProvider.of<HomeCubit>(
                            context,
                          ).bannerOneImageList.length,
                      itemBuilder: (context, index, realIndex) {
                        return InkWell(
                          onTap: () {
                            if (BlocProvider.of<HomeCubit>(
                                  context,
                                ).bannerOneImageList[index].itemsCount >
                                0) {
                              navigato(
                                context,
                                BannerProductsScreen(
                                  imageId:
                                      BlocProvider.of<HomeCubit>(
                                        context,
                                      ).bannerOneImageList[index].id,
                                ),
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              width: MediaQuery.sizeOf(context).width,
                              imageUrl:
                                  BlocProvider.of<HomeCubit>(
                                    context,
                                  ).bannerOneImageList[index].imagePath,
                              placeholder:
                                  (context, url) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: 1.0,
                                        color: AppColors.mainAppColor,
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) =>
                                      const Icon(Icons.error),
                              fadeInDuration: const Duration(seconds: 1),
                              height: 100.h,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        //  enlargeCenterPage: false,
                        aspectRatio: 30 / 9,
                        viewportFraction: 0.8,
                        // viewportFraction: 1.0,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                var cubit = BlocProvider.of<HomeCubit>(context);

                return ConditionalBuilder(
                  condition: cubit.newsMarqueeList.isNotEmpty,
                  builder:
                      (context) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        height: 12.sp + 15,
                        decoration: BoxDecoration(
                          color: AppColors.mainAppColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Marquee(
                          text: cubit.newsMarqueeList
                              .map((e) => e.newsText)
                              .join("      "),
                          style: GoogleFonts.alexandria(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 100.0,
                          pauseAfterRound: const Duration(milliseconds: 500),
                          startPadding: 10.0,

                          accelerationDuration: const Duration(
                            milliseconds: 500,
                          ),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: const Duration(
                            milliseconds: 500,
                          ),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                  fallback: (context) => const SizedBox.shrink(),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'shop_by_categories'.tr(),
                  style: GoogleFonts.alexandria(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<HomeCubit>(
                      context,
                    ).changeSelectIndexBottom(index: 1);
                  },
                  child: Text(
                    'see_more'.tr(),
                    style: GoogleFonts.alexandria(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.mainAppColor,
                      decorationThickness: 2,

                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mainAppColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 120.h,
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  CategoryCubit mainCategoryCubit =
                  BlocProvider.of<CategoryCubit>(context);
                  return ConditionalBuilder(
                    condition: state is GetMainCategorySuccess,
                    builder: (context) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                        mainCategoryCubit.mainCategoryList.isNotEmpty
                            ? mainCategoryCubit.mainCategoryList.length
                            : 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: InkWell(
                              onTap: () {
                                navigato(
                                  context,
                                  ProductCategoriesPage(
                                    categoryId:
                                    mainCategoryCubit
                                        .mainCategoryList[index]
                                        .categoryId,
                                    categoryName:
                                    (currentLocale.languageCode == 'ar')
                                        ? mainCategoryCubit
                                        .mainCategoryList[index]
                                        .categoryArName
                                        .toString()
                                        : mainCategoryCubit
                                        .mainCategoryList[index]
                                        .categoryEnName
                                        .toString(),
                                  ),
                                );
                              },
                              child: MainCategoryCard(
                                categoryName:
                                (currentLocale.languageCode == 'ar')
                                    ? mainCategoryCubit
                                    .mainCategoryList[index]
                                    .categoryArName
                                    .toString()
                                    : mainCategoryCubit
                                    .mainCategoryList[index]
                                    .categoryEnName
                                    .toString(),
                                imagePath:
                                mainCategoryCubit
                                    .mainCategoryList[index]
                                    .categoryImage
                                    .toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    fallback: (context) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: MainCategoryCard(
                                categoryName: '         ',
                                imagePath: '            ',
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                HomeCubit bestSellerProduct = BlocProvider.of<HomeCubit>(
                  context,
                );
                return ConditionalBuilder(
                  condition: state is! GetBestSellerLoading,
                  builder: (context) {
                    return (bestSellerProduct.bestSellerList.isNotEmpty)
                        ? ProductCard(
                      isFavoriteMap:
                      bestSellerProduct.itemsBestSellerFavorite,
                      product: bestSellerProduct.bestSellerList,

                      categoryName: 'bestsellers'.tr(),
                    )
                        : const SizedBox();
                  },
                  fallback: (context) {
                    return Skeletonizer(
                      enabled: false,
                      child: ProductCard(
                        product: bestSellerProduct.bestSellerList,
                        isFavoriteMap:
                        bestSellerProduct.itemsBestSellerFavorite,
                        categoryName: 'bestsellers'.tr(),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                HomeCubit newProduct = BlocProvider.of<HomeCubit>(context);
                return ConditionalBuilder(
                  condition: state is! GetNewProductLoading,
                  builder: (context) {
                    return (newProduct.newProductList.isNotEmpty)
                        ? ProductCard(
                      isFavoriteMap: newProduct.itemsNewProductFavorite,
                      product: newProduct.newProductList,

                      categoryName: 'new_arrival'.tr(),
                    )
                        : const SizedBox();
                  },
                  fallback: (context) {
                    return Skeletonizer(
                      enabled: true,
                      child: ProductCard(
                        product: newProduct.newProductList,
                        isFavoriteMap: newProduct.itemsNewProductFavorite,
                        categoryName: 'new_arrival'.tr(),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (BlocProvider.of<HomeCubit>(
                    context,
                  ).bannerTwoImageList.isEmpty) {
                    return Skeletonizer(
                      enabled: true,
                      child: Image.asset(
                        AppAssets.searchIcon,
                        height: 100.h,
                        fit: BoxFit.fill,
                      ),
                    );
                  }

                  return
                    // (BlocProvider.of<HomeCubit>(context).bannerTwoImageList[0].showGroup==0)?   const SizedBox() :
                    Visibility(
                      visible:
                      BlocProvider.of<HomeCubit>(
                        context,
                      ).bannerTwoImageList[0].showGroup !=
                          0,
                      child: CarouselSlider.builder(
                        itemCount:
                        BlocProvider.of<HomeCubit>(
                          context,
                        ).bannerTwoImageList.length,
                        itemBuilder: (context, index, realIndex) {
                          return InkWell(
                            onTap: () {
                              if (BlocProvider.of<HomeCubit>(
                                context,
                              ).bannerTwoImageList[index].itemsCount >
                                  0) {
                                navigato(
                                  context,
                                  BannerProductsScreen(
                                    imageId:
                                    BlocProvider.of<HomeCubit>(
                                      context,
                                    ).bannerTwoImageList[index].id,
                                  ),
                                );
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                width: MediaQuery.sizeOf(context).width,
                                imageUrl:
                                BlocProvider.of<HomeCubit>(
                                  context,
                                ).bannerTwoImageList[index].imagePath,
                                placeholder:
                                    (context, url) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: 1.0,
                                      color: AppColors.mainAppColor,
                                    ),
                                  ),
                                ),
                                errorWidget:
                                    (context, url, error) =>
                                const Icon(Icons.error),
                                fadeInDuration: const Duration(seconds: 1),
                                height: 100.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale,
                          //  enlargeCenterPage: false,
                          aspectRatio: 30 / 9,
                          viewportFraction: 0.8,

                          // viewportFraction: 1.0,
                        ),
                      ),
                    );
                },
              ),
            ),
            const SizedBox(height: 10),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                HomeCubit biggestDiscount = BlocProvider.of<HomeCubit>(context);
                return ConditionalBuilder(
                  condition: state is! GetBiggestDiscountLoading,
                  builder: (context) {
                    return (biggestDiscount.biggestDiscountList.isNotEmpty)
                        ? ProductCard(
                      isFavoriteMap:
                      biggestDiscount.itemsBiggestDiscountFavorite,
                      product: biggestDiscount.biggestDiscountList,

                      categoryName: 'biggest_discount'.tr(),
                    )
                        : const SizedBox();
                  },
                  fallback: (context) {
                    return Skeletonizer(
                      enabled: true,
                      child: ProductCard(
                        product: biggestDiscount.biggestDiscountList,
                        isFavoriteMap:
                        biggestDiscount.itemsBiggestDiscountFavorite,
                        categoryName: 'biggest_discount'.tr(),
                      ),
                    );
                  },
                );
              },
            ),

           BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            HomeCubit offerProduct = BlocProvider.of<HomeCubit>(context);
                            return ConditionalBuilder(
                              condition: state is! GetOfferProductLoading,
                              builder: (context) {
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: offerProduct.offerTwoList.length,
                                  itemBuilder: (context, index) {
                                    return (offerProduct.offerTwoList[index].showOffer ==
                                        true)
                                        ? const SizedBox()
                                        : ProductCard(
                                      isFavoriteMap: offerProduct.itemsOfferTwoFavorite,
                                      product:
                                      offerProduct.offerTwoList[index].offerItems,

                                      categoryName:
                                      (currentLocale.languageCode == 'ar')
                                          ? offerProduct
                                          .offerTwoList[index]
                                          .offerName
                                          : offerProduct
                                          .offerTwoList[index]
                                          .offerName,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 10);
                                  },
                                );
                              },
                              fallback: (context) {
                                return Skeletonizer(
                                  enabled: true,
                                  child: ProductCard(
                                    product: offerProduct.newProductList,
                                    isFavoriteMap: offerProduct.itemsOfferTwoFavorite,
                                    categoryName: 'ff',
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            HomeCubit offerProduct = BlocProvider.of<HomeCubit>(context);
                            return ConditionalBuilder(
                              condition: state is! GetOfferProductLoading,
                              builder: (context) {
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: offerProduct.offerList.length,
                                  itemBuilder: (context, index) {
                                    return (offerProduct.offerList[index].showOffer == 1)
                                        ? const SizedBox()
                                        : ProductCard(
                                      isFavoriteMap: offerProduct.itemsOfferFavorite,
                                      product: offerProduct.offerList[index].offerItems,

                                      categoryName:
                                      (currentLocale.languageCode == 'ar')
                                          ? offerProduct.offerList[index].offerName
                                          : offerProduct.offerList[index].offerName,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 10);
                                  },
                                );
                              },
                              fallback: (context) {
                                return Skeletonizer(
                                  enabled: true,
                                  child: ProductCard(
                                    product: offerProduct.newProductList,
                                    isFavoriteMap: offerProduct.itemsNewProductFavorite,
                                    categoryName: 'ff',
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                          child: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              if (BlocProvider.of<HomeCubit>(
                                context,
                              ).bannerThreeImageList.isEmpty) {
                                return Skeletonizer(
                                  enabled: true,
                                  child: Image.asset(
                                    AppAssets.searchIcon,
                                    height: 100.h,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              }

                              return Visibility(
                                visible:
                                    BlocProvider.of<HomeCubit>(
                                      context,
                                    ).bannerThreeImageList[0].showGroup !=
                                    0,
                                child: CarouselSlider.builder(
                                  itemCount:
                                      BlocProvider.of<HomeCubit>(
                                        context,
                                      ).bannerThreeImageList.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return InkWell(
                                      onTap: () {
                                        if (BlocProvider.of<HomeCubit>(
                                              context,
                                            ).bannerOneImageList[index].itemsCount >
                                            0) {
                                          navigato(
                                            context,
                                            BannerProductsScreen(
                                              imageId:
                                                  BlocProvider.of<HomeCubit>(
                                                    context,
                                                  ).bannerOneImageList[index].id,
                                            ),
                                          );
                                        }
                                      },

                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          width: MediaQuery.sizeOf(context).width,
                                          imageUrl:
                                              BlocProvider.of<HomeCubit>(
                                                context,
                                              ).bannerThreeImageList[index].imagePath,
                                          placeholder:
                                              (context, url) => Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value: 1.0,
                                                    color: AppColors.mainAppColor,
                                                  ),
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  const Icon(Icons.error),
                                          fadeInDuration: const Duration(seconds: 1),
                                          height: 100.h,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                                    //  enlargeCenterPage: false,
                                    aspectRatio: 30 / 9,
                                    viewportFraction: 0.8,
                                    // viewportFraction: 1.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
          ],
        ),
      ),
    );
  }
}
