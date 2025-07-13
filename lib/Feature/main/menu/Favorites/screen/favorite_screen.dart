import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constans/app_colors.dart';
import '../../../../../core/constans/constants.dart';
import '../../../../../core/network/local/cachehelper.dart';
import '../../../../../core/sharde/widget/navigation.dart';
import '../../../product_details/screen/product_details_screen.dart';
import '../cubit/favorite_cubit.dart';
import '../cubit/favorite_state.dart';


class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang')??'ar';
    final currentLocale = context.locale;
    return

Scaffold(
  backgroundColor: AppColors.backgroundAppColor,

  appBar: AppBar(
    scrolledUnderElevation: 0,
    elevation: 0,
    toolbarHeight: 40.0,
    backgroundColor: Colors.white,

    centerTitle: true,
    title: Text(
      'favorites'.tr(),
      style: GoogleFonts.alexandria(
        color: AppColors.mainAppColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,

      ),
    ),
  ),
  body:
  Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [

        10.verticalSpace,
        BlocProvider(
          create: (context)=>FavoriteCubit()..getFavoriteCategory(),

          child: BlocConsumer<FavoriteCubit,FavoriteState>(
            listener: (context,state){},
            builder: (context,state)
            {

             FavoriteCubit favoriteCubit=BlocProvider.of<FavoriteCubit>(context);
              return
                Expanded(
                  child: ListView.separated(
                      itemCount:favoriteCubit.favoriteList.length,
                      itemBuilder: (context,index){
                        return  InkWell(
                          onTap: (){
                            navigato(context, ProductDetailsScreen(productId:favoriteCubit.favoriteList[index].productID ,categoryId: favoriteCubit.favoriteList[index].categoryId,));
                          },
                          child: SizedBox(
                            height: 90.h,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            width: MediaQuery.sizeOf(context).width,
                                            imageUrl: favoriteCubit.favoriteList[index].productImage.toString(),
                                            placeholder: (context, url) => Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  value: 1.0,
                                                  color: AppColors.mainAppColor,
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                            fadeInDuration: const Duration(seconds: 1),
                                            height: 90.h,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (currentLocale.languageCode == 'ar')?
                                                favoriteCubit.favoriteList[index].productName ?? '':
                                                favoriteCubit.favoriteList[index].productEnName??'',
                                                maxLines: 2,

                                                style: GoogleFonts.alexandria(
                                                  textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:favoriteCubit.favoriteList[index].priceAfterDiscount.toString() ?? '0',
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
                                              if(favoriteCubit.favoriteList[index].price!=favoriteCubit.favoriteList[index].priceAfterDiscount)
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: favoriteCubit.favoriteList[index].price.toString() ?? '0',
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
                                                          decoration: TextDecoration.lineThrough, // خط مائل
                                                          decorationStyle: TextDecorationStyle.dashed, // تغيير النمط إلى خط متقطع
                                                          decorationColor: Colors.red, // تغيير لون الخط المائل
                                                          decorationThickness: 2.0, // زيادة سمك الخط المائل
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context,index)
                      {
                        return const SizedBox(height: 10,);
                      },
                     ),
                );
            },

          ),
        ),
      ],
    ),
  ),
)



     ;
  }
}
