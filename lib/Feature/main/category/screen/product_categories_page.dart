import 'package:abolashin/Feature/main/cart/screen/manager/cart_cubit.dart';
import 'package:abolashin/Feature/main/category/manager/category_cubit.dart';
import 'package:abolashin/Feature/main/category/manager/category_state.dart';
import 'package:abolashin/Feature/main/category/screen/widget/component_category_list_view.dart';
import 'package:abolashin/Feature/main/menu/Favorites/cubit/favorite_state.dart';
import 'package:abolashin/core/constans/app_assets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constans/app_colors.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/navigation.dart';
import '../../Home/home_screen.dart';
import '../../Home/manager/home_cubit.dart';
import '../../cart/screen/widget/counter_box_component.dart';
import '../../menu/Favorites/cubit/favorite_cubit.dart';
import '../../product_details/screen/product_details_screen.dart';
import 'package:abolashin/Feature/main/cart/screen/manager/chat_state.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ProductCategoriesPage extends StatelessWidget {
  final String categoryName;
  final dynamic categoryId;
  final List<Map<String, String>> products = [
    {'imagePath': 'assets/image/product1.jpg', 'productName': 'Product 1', 'price': '100', 'currency': 'USD'},
    {'imagePath': 'assets/image/product2.jpg', 'productName': 'Product 2', 'price': '200', 'currency': 'USD'},
    {'imagePath': 'assets/image/product3.jpg', 'productName': 'Product 3', 'price': '300', 'currency': 'USD'},
    {'imagePath': 'assets/image/product4.jpg', 'productName': 'Product 4', 'price': '400', 'currency': 'USD'},
  ];

  ProductCategoriesPage({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
    final currentLocale = context.locale;

    return Scaffold(
      backgroundColor: AppColors.backgroundAppColor,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: GoogleFonts.alexandria(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5C5C5C),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    navigatofinsh(context, const HomeScreen(), false);
                    BlocProvider.of<HomeCubit>(context).changeSelectIndexBottom(index: 2);
                  },
                  child: SvgPicture.asset(AppAssets.cartNoEmptyIcon),
                ),
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    final cartLength = context.read<CartCubit>().cartItems.length;
                    return Text(
                      '$cartLength',
                      style: GoogleFonts.alexandria(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mainAppColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: BlocProvider(
        create: (context) => CategoryCubit()
          ..getSubCategory(mainCategoryId: categoryId)
          ..getItemsForSubCategory(subCategoryId: categoryId),
        child: BlocConsumer<CategoryCubit, CategoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            final categoryCubit = context.read<CategoryCubit>();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ComponentCategoryListView(itemBloc: categoryCubit),
                  10.verticalSpace,
                  ConditionalBuilder(
                    condition: state is! GetItemsForSubCategoryLoading,
                    builder: (context) {
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.74,
                          ),
                          itemCount: categoryCubit.itemsSubCategoryList.length,
                          itemBuilder: (context, index) {
                            final product = categoryCubit.itemsSubCategoryList[index];
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    navigato(context, ProductDetailsScreen(
                                      productId: product.productId,
                                      categoryId: product.categoryId,
                                    ));

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: product.productImage ?? '',
                                              placeholder: (context, url) => const Skeletonizer(
                                                enabled: true,
                                                child: Center(child: Icon(Icons.image, size: 150)),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              width: MediaQuery.sizeOf(context).width,
                                              height: 150,
                                            ),
                                            Positioned(
                                              bottom: 5.h,
                                              left: currentLang == 'ar' ? 5.w : null,
                                              right: currentLang != 'ar' ? 5.w : null,
                                              child: CounterBox(
                                                image: product.productImage ?? '',
                                                nameAr: product.productArName,
                                                nameEn: product.productEnName,
                                                stockQuantity: product.stockQuantity,
                                                barcode: product.barCode,
                                                customerQuantity:product.customerQuantity,
                                                priceAfterDiscount: product.priceAfterDiscount,
                                                priceBeforeDiscount: product.price,
                                                productId: product.productId,
                                                customerquntatiy: product.customerQuantity,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: product.priceAfterDiscount.toStringAsFixed(2),
                                                        style: GoogleFonts.alexandria(
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w400,
                                                          color: AppColors.mainAppColor,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'currency'.tr(),
                                                        style: GoogleFonts.alexandria(
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w300,
                                                          color: AppColors.mainAppColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (product.price != product.priceAfterDiscount)
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: product.price.toStringAsFixed(2),
                                                          style: GoogleFonts.alexandria(
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.red,
                                                            decoration: TextDecoration.lineThrough,
                                                            decorationStyle: TextDecorationStyle.dashed,
                                                            decorationColor: Colors.red,
                                                            decorationThickness: 2.0,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: 'currency'.tr(),
                                                          style: GoogleFonts.alexandria(
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w300,
                                                            color: Colors.red,
                                                            decoration: TextDecoration.lineThrough,
                                                            decorationStyle: TextDecorationStyle.dashed,
                                                            decorationColor: Colors.red,
                                                            decorationThickness: 2.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        AutoSizeText(
                                          currentLocale.languageCode == 'ar'
                                              ? product.productArName
                                              : product.productEnName,
                                          maxLines: 2,
                                          maxFontSize: 12.sp,
                                          style: GoogleFonts.alexandria(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xff5C5C5C),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                if (product.price != product.priceAfterDiscount)
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadiusDirectional.horizontal(
                                          start: Radius.circular(20),
                                          end: Radius.circular(20),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Text(
                                        'special_offer'.tr(),
                                        style: GoogleFonts.alexandria(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                BlocBuilder<FavoriteCubit, FavoriteState>(
                                  builder: (context, state) {
                                    return Positioned(
                                      top: 5,
                                      left: 5,
                                      child: IconButton(
                                        icon: Icon(
                                          categoryCubit.itemsForSubCategoryFavorite[product.barCode] ?? false
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: categoryCubit.itemsForSubCategoryFavorite[product.barCode] ?? false
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          context.read<FavoriteCubit>().addFavorite(
                                            barcode: product.barCode,
                                            favorite: categoryCubit.itemsForSubCategoryFavorite,
                                            productId: product.productId,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                    fallback: (context) => _buildSkeletonGrid(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        height: 600,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.image, size: 122)),
                  AutoSizeText(
                    product['productName']!,
                    maxLines: 2,
                    maxFontSize: 12.sp,
                    style: GoogleFonts.alexandria(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff5C5C5C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: product['price']!,
                              style: GoogleFonts.alexandria(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.orange,
                              ),
                            ),
                            TextSpan(
                              text: ' ${product['currency']}',
                              style: GoogleFonts.alexandria(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF7B700),
                          borderRadius: BorderRadius.circular(17.r),
                        ),
                        width: 30.w,
                        height: 30.h,
                        child: const Icon(Icons.add, color: Colors.white, size: 25),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
