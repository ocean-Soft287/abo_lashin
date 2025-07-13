import 'package:abolashin/Feature/Auth/profile/screen/profile_screen.dart';
import 'package:abolashin/Feature/main/Home/manager/home_cubit.dart';
import 'package:abolashin/Feature/main/menu/Privacy_Policy/screen/privacy_policy_screen.dart';
import 'package:abolashin/core/sharde/widget/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constans/app_assets.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/show_logout_dialog.dart';
import '../Favorites/screen/favorite_screen.dart';
import '../PreviousOrders/screen/previous_orders.dart';
import '../about_us/screen/about_us_screen.dart';
import '../frequently_asked_questions/scessn/fa_screen.dart';
class MenuScreen extends StatelessWidget {
 const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang')??'ar';
    final currentLocale = context.locale;
    List<Map<String, dynamic>> listMenu = [
      {
        'title': 'my_orders'.tr(),
        'icon': 'assets/icons/oreder_request.svg',
         'screen': const PreviousOrders(),
      },
      {
        'title': 'favorites'.tr(),
        'icon': 'assets/icons/favorite.svg',
      'screen': const FavoriteScreen(),
      },
      {
        'title': 'about_us'.tr(),
        'icon': 'assets/icons/about_us.svg',
      //  'screen': AboutUsScreen(),
      'screen': const AboutUsScreen(),


      },
      {
        'title': 'frequently_asked_questions'.tr(),
        'icon': 'assets/icons/gh.svg',
      'screen':  const FAQPage(),
      },
 // {
 //        'title': 'saved_addresses'.tr(),
 //        'icon': 'assets/icons/gh.svg',
 //      'screen':  SavedAddressesScreen(),
 //      },

      {
        'title': 'policy_privacy'.tr(),
        'icon': 'assets/icons/priv.svg',
        'screen': const PrivacyPolicyScreen(),
      }, {
        'title': 'change_language'.tr(),
        'icon': 'assets/icons/lang.svg',
        // 'screen': const ShowDialog(),
      },
      {
        'title': 'logout'.tr(),
        'icon': AppAssets.logOutIcon,
        // 'screen': const ShowDialog(),
      },


    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      child: Column(
        children: [
          ListTile(
onTap: (){
  navigato(context, ProfileScreen());
},
            leading: SvgPicture.asset(
              'assets/icons/user.svg',
              width: 40.w,
              height: 40.0.h,
              fit: BoxFit.contain,
            ),
            title: Text(
              '${'welcome_message'.tr()}${customerName??''}',
              style:GoogleFonts.alexandria(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color:Colors.black,

              ),

            ),

            subtitle: Text(
              'account_info'.tr(),
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                color: const Color(0xff5A5A5A),

              ),
            ),

            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),

          ),
       const SizedBox(height: 10,),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.1,
              ),
              itemCount: listMenu.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    if(index==5)
                      {

                        if (currentLocale.languageCode == 'ar') {

                          context.setLocale(const Locale('en'));
                          CacheHelper.saveData(key: 'changeLang', value: 'en');
                        } else {

                          context.setLocale(const Locale('ar'));
                          CacheHelper.saveData(key: 'changeLang', value: 'ar');
                        }

                        BlocProvider.of<HomeCubit>(context).changeSelectIndexBottom(index: 0);

                      }
                    if(index==6)
                      {
                        showLogoutConfirmationDialog(context:context);

                      }
                    else
                      {
                        navigato(context,  listMenu[index]['screen'],);
                      }


                  },
                  child: Container(

                    decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                         child:SvgPicture.asset(
                           listMenu[index]['icon'],
                           width: 60,
                           height: 60,
                           fit: BoxFit.contain,
                         ),
                        ),
                    const SizedBox(height: 10,),
                        Text(
                          '${listMenu[index]['title']}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.alexandria(
                            color: const Color(0xff5A5A5A),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,

                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
}



