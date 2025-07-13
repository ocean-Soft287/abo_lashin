

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../core/constans/app_assets.dart';

import '../../../core/constans/app_colors.dart';
import 'manager/home_cubit.dart';
import 'manager/home_state.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        HomeCubit homeCubit = BlocProvider.of(context);
        return Scaffold(
              backgroundColor: const Color(0xfff3f3f3),
          body: SafeArea(

            child: homeCubit.screen[homeCubit.currentIndex],
          ),
          bottomNavigationBar: SalomonBottomBar(

            backgroundColor: Colors.white,

            curve: Curves.easeOutQuint,
            currentIndex: BlocProvider.of<HomeCubit>(context).currentIndex,
            onTap: (index) {
              BlocProvider.of<HomeCubit>(context)
                  .changeSelectIndexBottom(index: index);
            },
            items: [
              SalomonBottomBarItem(

                icon: SvgPicture.asset(AppAssets.homeIcon),
                title:  Text('home'.tr()),
                selectedColor: AppColors.mainAppColor,
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(AppAssets.sectionIcon),
                title: Text('categories'.tr()),
                selectedColor: AppColors.mainAppColor,
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(AppAssets.cartIcon),
                title: Text('cart'.tr()),
                selectedColor: AppColors.mainAppColor,
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(AppAssets.menuIcon),
                title: Text('menu'.tr()),
                selectedColor: AppColors.mainAppColor,
              ),
            ],
          ),
        );
      },
    );
  }
}


