import 'package:abolashin/Feature/Auth/login/screen/login_screen.dart';
import 'package:abolashin/core/constans/app_colors.dart';
import 'package:abolashin/core/sharde/widget/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Feature/main/Home/manager/home_cubit.dart';
import '../../../Feature/main/cart/screen/manager/cart_cubit.dart';
import '../../network/local/cachehelper.dart';
import '../../network/local/hive_manger.dart';

void showLogoutConfirmationDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'logout_confirmation'.tr(),
          style: GoogleFonts.alexandria(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'logout_confirmation_message'.tr(),
          style: GoogleFonts.alexandria(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'cancel'.tr(),
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              CacheHelper.removeData(key: 'customerID').then((value) {
                CacheHelper.removeData(key: 'customerName');
                navigatofinsh(context, const LoginScreen(), false);
                BlocProvider.of<HomeCubit>(context).changeSelectIndexBottom(index: 0);
                HiveCrudManager.deleteList(cartBox, cartKey);

              });
            },
            child: Text(
              'confirm'.tr(),
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.mainAppColor,
              
              ),
            ),
          ),
        ],
      );
    },
  );
}
