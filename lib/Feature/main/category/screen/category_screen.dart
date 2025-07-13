import 'package:abolashin/Feature/main/category/manager/category_cubit.dart';
import 'package:abolashin/Feature/main/category/manager/category_state.dart';
import 'package:abolashin/Feature/main/category/screen/product_categories_page.dart';
import 'package:abolashin/core/sharde/widget/navigation.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constans/app_assets.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../Search/screen/search_screen.dart';
import 'main_category_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang')??'ar';
    final currentLocale = context.locale;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          5.verticalSpace,
          InkWell(
            onTap: (){
              navigato(context, const SearchScreen());
            },
            child: Container(

              padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 20),
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
                        color:const Color(0xff6A6A6A),
                      ),
                    ),
                  ),
                  SvgPicture.asset(AppAssets.searchIcon)
                ],
              ),
            ),
          ),
        Expanded(
          child: BlocBuilder<CategoryCubit,CategoryState>(
            builder: (context,state)
            {
              CategoryCubit mainCategoryCubit=BlocProvider.of<CategoryCubit>(context);
              return  ConditionalBuilder(
                condition:state is GetMainCategorySuccess ,
                builder: (context){
                  return  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: mainCategoryCubit.mainCategoryList.length,
                    itemBuilder: (context, index) {
                      return  InkWell(
                        onTap: () {
                          navigato(
                            context,
                            ProductCategoriesPage(
                              categoryId: mainCategoryCubit.mainCategoryList[index].categoryId,
                              categoryName:
                              (currentLocale.languageCode == 'ar')?
                              mainCategoryCubit.mainCategoryList[index].categoryArName.toString()
                                  :
                              mainCategoryCubit.mainCategoryList[index].categoryEnName.toString()
                              ,

                            ),
                          );
                        },
                        child: MainCategoryCard(
                          categoryName:
                          (currentLocale.languageCode == 'ar')?
                          mainCategoryCubit.mainCategoryList[index].categoryArName.toString()
                              :
                          mainCategoryCubit.mainCategoryList[index].categoryEnName.toString()
                          ,

                          imagePath: mainCategoryCubit.mainCategoryList[index].categoryImage.toString(),
                        ),
                      );

                    },
                  );
                },
                fallback: (context){
                  return Skeletonizer(
                    enabled: true,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return const MainCategoryCard(
                          categoryName: '         ',
                          imagePath: '            ',
                        );

                      },
                    ),
                  );
                },


              );
            },

          ),
        ),

     


        ],
      ),
    );
  }
}



