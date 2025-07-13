import 'package:abolashin/Feature/main/cart/screen/manager/chat_state.dart';
import 'package:abolashin/Feature/main/product_details/manager/product_details_state.dart';
import 'package:abolashin/core/constans/app_assets.dart';
import 'package:abolashin/core/constans/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/navigation.dart';
import '../../Home/home_screen.dart';
import '../../Home/manager/home_cubit.dart';
import '../../Home/widget/porduct_card.dart';
import '../../Search/screen/search_screen.dart';
import '../../cart/screen/manager/cart_cubit.dart';
import '../../cart/screen/widget/counter_box_component.dart';
import '../../category/manager/category_cubit.dart';
import '../../category/manager/category_state.dart';
import '../manager/product_details_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  dynamic productId;
  dynamic categoryId;
  ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.categoryId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
    final currentLocale = context.locale;
    return Scaffold(
      backgroundColor: AppColors.backgroundAppColor,
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    navigatofinsh(context, const HomeScreen(), false);
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
                      '${cubit.cartItems.isNotEmpty? cubit.cartItems.length: 0}',
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
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0),
          child: InkWell(
            onTap: () {
              navigato(context, const SearchScreen());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
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
        ),
        backgroundColor: AppColors.backgroundAppColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                BlocProvider(
                  create:
                      (context) =>
                          ProductDetailsCubit()
                            ..getProductDetails(productId: widget.productId),
                  child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                    builder: (context, state) {
                      ProductDetailsCubit productDetailsCubit = BlocProvider.of(
                        context,
                      );

                      return ConditionalBuilder(
                        condition:
                            state is! GetProductDetailsLoading &&
                            productDetailsCubit.productDetailsList.isNotEmpty,
                        builder: (context) {
                          return Column(
                            children: [
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        CachedNetworkImage(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          imageUrl:
                                              productDetailsCubit
                                                  .productDetailsList[0]
                                                  .productcImage
                                                  ?.toString() ??
                                              '',

                                          placeholder:
                                              (context, url) => Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(
                                                          AppColors
                                                              .mainAppColor,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  const Icon(Icons.error),
                                          fadeInDuration: const Duration(
                                            seconds: 1,
                                          ),
                                          height: 150.h,

                                          fit: BoxFit.contain,
                                        ),
                                        Positioned(
                                          bottom: 5.h,
                                          left:
                                              Localizations.localeOf(
                                                        context,
                                                      ).languageCode ==
                                                      'ar'
                                                  ? 5.w
                                                  : null,
                                          right:
                                              Localizations.localeOf(
                                                        context,
                                                      ).languageCode ==
                                                      'ar'
                                                  ? null
                                                  : 5.w,
                                          child: CounterBox(
                                            stockQuantity: productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit.selectedUnit]
                                                .stockQty ??
                                                0,
                                            barcode: productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit.selectedUnit]
                                                .barcode ??
                                                '',
                                            customerQuantity: productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit.selectedUnit]
                                                .customerQuantity ??
                                                0,
                                            customerquntatiy: productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit.selectedUnit]
                                                .customerQuantity ??
                                                0,
                                            image: productDetailsCubit
                                                .productDetailsList[0]
                                                .productcImage
                                                .toString(),
                                            nameAr:
                                            '${productDetailsCubit.productDetailsList[0].productArName} * ${productDetailsCubit.productDetailsList[0].productUnitImages![productDetailsCubit.selectedUnit].unitArName}',
                                            nameEn:
                                            '${productDetailsCubit.productDetailsList[0].productEnName} * ${productDetailsCubit.productDetailsList[0].productUnitImages![productDetailsCubit.selectedUnit].unitEnName}',
                                            priceAfterDiscount: productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit.selectedUnit]
                                                .priceAfterDiscount
                                                ?.toDouble() ??
                                                0.0,
                                            priceBeforeDiscount: productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit.selectedUnit]
                                                .price
                                                ?.toDouble() ??
                                                0.0,
                                            productId: widget.productId,
                                          ),


                                        ),
                                        if (productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit
                                                    .selectedUnit]
                                                .price !=
                                            productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit
                                                    .selectedUnit]
                                                .priceAfterDiscount)
                                          Positioned(
                                            top: 5,
                                            right: 5,

                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadiusDirectional.horizontal(
                                                      start: Radius.circular(5),
                                                      end: Radius.circular(5),
                                                    ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
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
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      (currentLocale.languageCode == 'ar')
                                          ? '${productDetailsCubit.productDetailsList[0].productArName}'
                                              '${(
                                                  //productDetailsCubit.selectedUnit == 0 &&
                                                  productDetailsCubit.productDetailsList[0].productUnitImages![productDetailsCubit.selectedUnit].unitValue == 1) ? '' : ' * ${productDetailsCubit.productDetailsList[0].productUnitImages![productDetailsCubit.selectedUnit].unitValue}'}'
                                          : '${productDetailsCubit.productDetailsList[0].productEnName}'
                                              '${(
                                                  //productDetailsCubit.selectedUnit == 0 &&
                                                  productDetailsCubit.productDetailsList[0].productUnitImages![0].unitValue == 1) ? '' : ' * ${productDetailsCubit.productDetailsList[0].productUnitImages![productDetailsCubit.selectedUnit].unitValue}'}',

                                      maxLines: 2,

                                      style: GoogleFonts.alexandria(
                                        textStyle: TextStyle(
                                          fontSize: 16.sp,

                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: (productDetailsCubit
                                                            .productDetailsList[0]
                                                            .productUnitImages![productDetailsCubit
                                                                .selectedUnit]
                                                            .priceAfterDiscount)
                                                    .toStringAsFixed(2),
                                                style: GoogleFonts.alexandria(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.mainAppColor,
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'currency'.tr(),
                                                style: GoogleFonts.alexandria(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w300,
                                                  color: AppColors.mainAppColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit
                                                    .selectedUnit]
                                                .price !=
                                            productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages![productDetailsCubit
                                                    .selectedUnit]
                                                .priceAfterDiscount)
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: (productDetailsCubit
                                                              .productDetailsList[0]
                                                              .productUnitImages![productDetailsCubit
                                                                  .selectedUnit]
                                                              .price)
                                                      .toStringAsFixed(2),
                                                  style: GoogleFonts.alexandria(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.red,
                                                    decoration:
                                                        TextDecoration
                                                            .lineThrough,
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .dashed,
                                                    decorationColor: Colors.red,
                                                    decorationThickness: 2.0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'currency'.tr(),
                                                  style: GoogleFonts.alexandria(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.red,
                                                    decoration:
                                                        TextDecoration
                                                            .lineThrough,
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .dashed,
                                                    decorationColor: Colors.red,
                                                    decorationThickness: 2.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 40,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            productDetailsCubit
                                                .productDetailsList[0]
                                                .productUnitImages
                                                ?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          final isSelected =
                                              productDetailsCubit
                                                  .selectedUnit ==
                                              index;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                            child: ChoiceChip(
                                              label: Text(
                                                (currentLocale.languageCode ==
                                                        'ar')
                                                    ? productDetailsCubit
                                                        .productDetailsList[0]
                                                        .productUnitImages![index]
                                                        .unitArName
                                                    : productDetailsCubit
                                                        .productDetailsList[0]
                                                        .productUnitImages![index]
                                                        .unitEnName,
                                                style: TextStyle(
                                                  color:
                                                      isSelected
                                                          ? Colors.white
                                                          : AppColors
                                                              .mainAppColor,
                                                  fontWeight:
                                                      isSelected
                                                          ? FontWeight.bold
                                                          : FontWeight.w500,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              selected: isSelected,
                                              onSelected: (_) {
                                                context
                                                    .read<ProductDetailsCubit>()
                                                    .changeSelectedUnit(
                                                      index: index,
                                                    );
                                              },
                                              selectedColor:
                                                  AppColors.mainAppColor,
                                              checkmarkColor:
                                                  AppColors.secondAppColor,
                                              backgroundColor: Colors.grey[200],
                                              // side: BorderSide(color: AppColors.mainAppColor),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 5),
                                    Text(
                                      'description'.tr(),

                                      maxLines: 1,

                                      style: GoogleFonts.alexandria(
                                        textStyle: TextStyle(
                                          fontSize: 16.sp,

                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      productDetailsCubit
                                              .productDetailsList[0]
                                              .specifications
                                              .toString(),
                                      maxLines: 5,

                                      style: GoogleFonts.alexandria(
                                        textStyle: TextStyle(
                                          fontSize: 13.sp,

                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        fallback: (context) {
                          return Skeletonizer(
                            enabled: true,
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Icon(Icons.image, size: 150),
                                      ),
                                      // CachedNetworkImage(
                                      //
                                      //   width: MediaQuery.sizeOf(context).width,
                                      //   imageUrl:
                                      //  AppAssets.appleTestIcon,
                                      //   placeholder: (context, url) => Padding(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     child: Center(
                                      //       child: CircularProgressIndicator(
                                      //         value: 1.0,
                                      //         color: AppColors.mainAppColor,
                                      //       ),
                                      //     ),
                                      //   ),
                                      //   errorWidget: (context, url, error) => const Icon(Icons.error),
                                      //   fadeInDuration: const Duration(seconds: 1),
                                      //   height:200.h,
                                      //
                                      //   fit: BoxFit.fill,
                                      // ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'تفاح اخضر مستورد 1كجم',

                                        maxLines: 2,

                                        style: GoogleFonts.alexandria(
                                          textStyle: TextStyle(
                                            fontSize: 16.sp,

                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '500.000',
                                              style: GoogleFonts.alexandria(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.mainAppColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'currency'.tr(),
                                              style: GoogleFonts.alexandria(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.mainAppColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'الوصف',

                                        maxLines: 1,

                                        style: GoogleFonts.alexandria(
                                          textStyle: TextStyle(
                                            fontSize: 16.sp,

                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'استعد لتذوق الطعم اللذيذ لبطاطس القلي الهشة! مع طبيعتها المتعددة الاستخدامات وطعمها اللذيذ تعتبر بطاطس القلي مكوتا أساسيا في مطابخ العديد من الثقافات في جميع أنحاء العالم.',

                                        maxLines: 5,

                                        style: GoogleFonts.alexandria(
                                          textStyle: TextStyle(
                                            fontSize: 13.sp,

                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16),
                  child: BlocProvider(
                    create:
                        (context) =>
                            CategoryCubit()..getItemsForSubCategory(
                              subCategoryId: widget.categoryId,
                            ),
                    child: BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        CategoryCubit similarProduct =
                            BlocProvider.of<CategoryCubit>(context);
                        return ConditionalBuilder(
                          condition:
                              state is! GetItemsForSubCategoryLoading &&
                              similarProduct.itemsSubCategoryList.isNotEmpty,
                          builder: (context) {
                            return ProductCard(
                              isFavoriteMap:
                                  similarProduct.itemsForSubCategoryFavorite,
                              product: similarProduct.itemsSubCategoryList,

                              categoryName: 'similar_products'.tr(),
                            );
                          },
                          fallback: (context) {
                            return Skeletonizer(
                              enabled: true,
                              child: ProductCard(
                                isFavoriteMap:
                                    similarProduct.itemsForSubCategoryFavorite,
                                product: similarProduct.itemsSubCategoryList,

                                categoryName: 'similar_products'.tr(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                60.verticalSpace,
                //
                // 10.verticalSpace,
                // Padding(
                //   padding: const EdgeInsetsDirectional.only(
                //     start: 16,
                //
                //   ),
                //   child: ProductCard(
                //     imagePath: AppAssets.appleTest2Icon,
                //
                //     productName: 'product'.tr(),
                //     price: '3.000',
                //     categoryName: 'recently_ordered_products'.tr(),
                //   ),
                // ),
              ],
            ),
          ),

          //       SizedBox( width: MediaQuery.sizeOf(context).width*.7,child: Container(
          //         margin: const EdgeInsets.symmetric(vertical: 10),
          //         child: DefaultButton(
          //
          // hasIcon: true,
          //           icon: SvgPicture.asset(AppAssets.cartAddIcon),
          //           text: 'add_to_cart'.tr(),function: (){
          //
          //
          //           BlocProvider.of<AddOrderCubit>(context).addItem(productId: productId);
          //
          //         },backgroundColor: AppColors.mainAppColor,),
          //       ))
        ],
      ),
    );
  }
}
