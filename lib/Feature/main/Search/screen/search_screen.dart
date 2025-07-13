import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constans/app_assets.dart';
import '../../../../core/constans/app_colors.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';

import '../../../../core/sharde/widget/navigation.dart';
import '../../product_details/screen/product_details_screen.dart';
import '../manager/search_cubit.dart';
import '../manager/search_state.dart';
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang')??'ar';
    final currentLocale = context.locale;
    return Scaffold(
        backgroundColor: AppColors.backgroundAppColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundAppColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1,vertical: 0),
            child: TextField(

              onChanged: (String value) {

                if (BlocProvider.of<SearchCubit>(context).debounce?.isActive ?? false) {
                  BlocProvider.of<SearchCubit>(context).debounce?.cancel();
                }


                BlocProvider.of<SearchCubit>(context).debounce = Timer(const Duration(milliseconds: 500), () {
                  if (value.isEmpty) {

                    BlocProvider.of<SearchCubit>(context).searchKey(searchKey: '');
                  } else if (value.length >= 3) {

                    BlocProvider.of<SearchCubit>(context).searchKey(searchKey: value);
                  }
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'search'.tr(),
                hintStyle: GoogleFonts.alexandria(
              textStyle: TextStyle(
              fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color:const Color(0xff6A6A6A),
              ),
            ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SvgPicture.asset(AppAssets.searchIcon,width: 20,height: 20,),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Make the corners rounded
                  borderSide: BorderSide.none, // No border side color
                ),
              ),



              style:   GoogleFonts.alexandria(
            textStyle: TextStyle(
            fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color:const Color(0xff6A6A6A),
            ),
          ),
            ),
          ),

        ),

        body:
        Column(
          children: [

            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {

                if (state is SearchLoading) {
                  return  Center(
                    child: Lottie.asset(
                      AppAssets.loading,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fill,
                    ),
                  );
                }


                if (state is SearchSuccess) {
                  final searchProduct = BlocProvider.of<SearchCubit>(context);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                      child: ListView.separated(
                        itemCount: searchProduct.searchList.length,
                        itemBuilder: (context, index) {
                          final item = searchProduct.searchList[index];


                          return
                            InkWell(
                              onTap: (){
                                navigato(context, ProductDetailsScreen(productId:item.productId ,categoryId: item.categoryId,));

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
                                                imageUrl: item.productImage.toString(),
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
                                                    item.productArName:
                                                    item.categoryEnName,
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
                                                          text:item.priceAfterDiscount.toString() ,
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
                                                  if(item.price!=item.priceAfterDiscount)
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: item.price.toString(),
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
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                      ),
                    ),
                  );



                }

                if (state is SearchError) {
                  return Center(
                    child: SvgPicture.asset(
                      AppAssets.notFound,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                    ),
                  );
                }

                return Center(
                  child: SvgPicture.asset(
                    AppAssets.notFound,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,  // Set fit type (optional)
                  ),
                );
              },
            )
          ],
        )







    );
  } }

