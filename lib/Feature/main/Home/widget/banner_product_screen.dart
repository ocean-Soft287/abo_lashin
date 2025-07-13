import 'package:abolashin/Feature/main/Home/manager/home_cubit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constans/app_colors.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/navigation.dart';
import '../../cart/screen/widget/counter_box_component.dart';
import '../../menu/Favorites/cubit/favorite_cubit.dart';
import '../../menu/Favorites/cubit/favorite_state.dart';
import '../../product_details/screen/product_details_screen.dart';
import '../manager/home_state.dart';
class BannerProductsScreen extends StatefulWidget {
  var imageId;
  BannerProductsScreen({super.key,required this.imageId});

  @override
  State<BannerProductsScreen> createState() => _BannerProductsScreenState();
}

class _BannerProductsScreenState extends State<BannerProductsScreen> {
  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang')??'ar';
    final currentLocale = context.locale;
    return Scaffold(
      backgroundColor: AppColors.backgroundAppColor,
      appBar:  AppBar(

        title: Text('banner_categories'.tr(),style: GoogleFonts.alexandria(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xff5C5C5C),
        ),),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,

      ),
      body:  BlocProvider(
        create: (context)=>HomeCubit()..getProductsBannerId(imageName: 1),
        child: BlocConsumer<HomeCubit,HomeState>(
          listener: (context,state){},
          builder: (context,state){
            HomeCubit bannerProductCubit=BlocProvider.of(context);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  ConditionalBuilder(
                    condition:state is! GetProductBannerLoading ,
                    builder: (context){
                      return  Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.74,
                          ),
                          itemCount: bannerProductCubit.productsBannerIdList.isNotEmpty?bannerProductCubit.productsBannerIdList.length:0,
                          itemBuilder: (context, index) {
                            var product = bannerProductCubit.productsBannerIdList[index];
                            return Stack(
                              children: [

                                InkWell(
                                  onTap: () {
                                    navigato(context, ProductDetailsScreen(productId:product.productId ,categoryId: product.categoryId,));
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
                                              imageUrl: product.productImage.toString(),
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
                                              child: CounterBox(
                                                image:product.productImage.toString(),
                                                nameAr:  product.productArName,
                                                nameEn:  product.productEnName,
                                                stockQuantity: product.stockQuantity,
                                                barcode: product.barCode,
                                                customerQuantity: product.stockQuantity,
                                                priceAfterDiscount: product.priceAfterDiscount,
                                                priceBeforeDiscount:  product.price,
                                                productId:  product.productId, customerquntatiy: product.customerQuantity,
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
                                                        text: (product.priceAfterDiscount).toStringAsFixed(2),

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
                                                if(product.price!=product.priceAfterDiscount)
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: (product.price).toStringAsFixed(2),
                                                          style: GoogleFonts.alexandria(
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.red,
                                                            decoration: TextDecoration.lineThrough, // خط مائل
                                                            decorationStyle: TextDecorationStyle.dashed, // تغيير النمط إلى خط متقطع
                                                            decorationColor: Colors.red, // تغيير لون الخط المائل
                                                            decorationThickness: 2.0, // زيادة سمك الخط المائل
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
                                          (currentLocale.languageCode == 'ar')?
                                          product.productArName
                                              :
                                          product.productEnName
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
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                if(product.price!=product.priceAfterDiscount)
                                  Positioned(
                                    top:5,
                                    right: 5,

                                    // المسافة من اليسار
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
                                BlocBuilder<FavoriteCubit,FavoriteState>(
                                  builder: (context,state)
                                  {
                                    return Positioned(
                                      top:5,
                                      left: 5,
                                      child: IconButton(
                                        icon: Icon(
                                          bannerProductCubit.productsBannerIdFavorite[product.productId] ?? false
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:  bannerProductCubit.productsBannerIdFavorite[product.productId] ?? false
                                              ? Colors.red
                                              : Colors.grey,
                                        ),

                                        onPressed: (){
                                          BlocProvider.of<FavoriteCubit>(
                                              context)
                                              .addFavorite(
                                            barcode:product.barCode ,
                                            favorite:  bannerProductCubit.productsBannerIdFavorite
                                            ,
                                            productId: product.productId,
                                          );

                                        },  ),
                                    );
                                  },

                                ),
                              ],
                            )
                            ;
                          },
                        ),
                      );
                    },
                    fallback: (context){
                      return  Skeletonizer(
                        enabled: true,
                        child: SizedBox(
                          height: 600,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two items per row
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.7, // Adjust the aspect ratio for each item
                            ),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              var product = bannerProductCubit.productsBannerIdList[index];
                              return InkWell(
                                onTap: () {
                                  // Navigate to ProductDetailsScreen (you can replace this line with your navigation logic)
                                  //print('Tapped on ${product['productName']}');
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
                                      const Center(child: Icon(Icons.image,size: 150,)),
                                      AutoSizeText(
                                        product.productArName,
                                        maxLines: 2,
                                        maxFontSize: 12.sp,
                                        style: GoogleFonts.alexandria(
                                          textStyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xff5C5C5C),
                                          ),
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
                                                  text: '',
                                                  style: GoogleFonts.alexandria(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.orange, // You can change this color
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' ',
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
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },

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
