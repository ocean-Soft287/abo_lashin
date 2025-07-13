import 'package:abolashin/Feature/main/product_details/screen/product_details_screen.dart';
import 'package:abolashin/core/sharde/widget/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constans/app_colors.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../cart/screen/widget/counter_box_component.dart';
import '../../menu/Favorites/cubit/favorite_cubit.dart';
import '../../menu/Favorites/cubit/favorite_state.dart';
import 'item_category_offer.dart';

class ProductCard extends StatelessWidget {
  List product;
  final String categoryName;

  final dynamic isFavoriteMap;


  ProductCard({
    super.key,
    required this.product,
    required this.categoryName
    ,
   required this.isFavoriteMap


  });

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang')??'ar';
    final currentLocale = context.locale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(categoryName, style: GoogleFonts.alexandria(
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color:Colors.black,
              ),
            ),

            ),
            GestureDetector(
              onTap: () {
             navigato(context, ItemsCategoryOffer(

               isFavoriteMap: isFavoriteMap,

               categoryName:categoryName ,
               product: product,
             ));
              },
              child: Text(
                'see_more'.tr(),
                style: GoogleFonts.alexandria(
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.mainAppColor,
                  decorationThickness:2 ,

                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color:AppColors.mainAppColor,
                  ),
                ),
              ),
            )
          ],
        ),
        5.verticalSpace,

        SizedBox(
          height:225.h,

          child:

         ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.length,
              itemBuilder: (context, index) {

                return   Stack(
                  children: [
                    InkWell(
                      onTap: () {
                      navigato(context, ProductDetailsScreen(productId:product[index].productId ,categoryId: product[index].categoryId,));



                      },
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                          width: MediaQuery.sizeOf(context).width / 2,
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
                                      imageUrl: product[index].productImage.toString(),
                                      placeholder: (context, url) => const Skeletonizer(
                                        enabled: true,
                                        child: Center(
                                          child: Icon(Icons.image, size: 150),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 150,
                                    ),
                                    Positioned(
                                      bottom: 5.h,
                                      left: Localizations.localeOf(context).languageCode == 'ar' ? 5.w : null,
                                      right: Localizations.localeOf(context).languageCode == 'ar' ? null : 5.w,
                                      child:  CounterBox(
                                        stockQuantity: product[index].stockQuantity,
                                        barcode: product[index].barCode,
                                        customerQuantity: product[index].customerQuantity,
                                        image:product[index].productImage.toString() ?? '',
                                        nameAr:  product[index].productArName,
                                        nameEn:  product[index].productEnName,
                                        priceAfterDiscount: product[index].priceAfterDiscount,
                                        priceBeforeDiscount:  product[index].price,
                                        productId:  product[index].productId, customerquntatiy:    product[index].customerQuantity,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: (product[index].priceAfterDiscount ?? 0.0).toStringAsFixed(2),
                                            style: GoogleFonts.alexandria(
                                              fontSize: 13.sp,
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
                                    if(product[index].price!=product[index].priceAfterDiscount)
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: (product[index].price ?? 0.0).toStringAsFixed(2),
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
                                const SizedBox(height: 10),
                                AutoSizeText(
                                  (currentLocale.languageCode == 'ar')?
                                  product[index].productArName
                                  :
                                  product[index].productEnName
                                  ,
                                  maxLines: 2,
                                  maxFontSize: 12.sp,
                                  style: GoogleFonts.alexandria(
                                    textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w300,
                                      color: const Color(0xff5C5C5C),
                                    ),
                                  ),
                                ), const Spacer(),
                              ],
                            ),
                          ),



                        ],
                      ),
                    ),
                    if(product[index].price!=product[index].priceAfterDiscount)
                      Positioned(
                        top:5,
                        right: 5,


                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadiusDirectional.horizontal(
                                start:Radius.circular(20),
                                end: Radius.circular(20)
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
                    // if(product[index].stockQuantity==0.0)
                    //   Center(child: Image.asset(AppAssets.outOfStock,height: 150,)),
                      BlocBuilder<FavoriteCubit,FavoriteState>(
                      builder: (context,state)
                      {
                        return Positioned(
                          top:5,
                          left: 5,
                          child: IconButton(
                            icon: Icon(
                              isFavoriteMap[product[index].barCode] ?? false
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavoriteMap[product[index].barCode] ?? false
                                  ? Colors.red
                                  : Colors.grey,
                            ),

                            onPressed: (){
                              BlocProvider.of<FavoriteCubit>(
                                  context)
                                  .addFavorite(
                                barcode:product[index].barCode ,
                                favorite: isFavoriteMap
                                ,
                                productId: product[index].productId,
                              );

                            },  ),
                        );
                      },

                    ),

                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 5,);
              },
            ),
          ),

      ],
    );
  }
}
