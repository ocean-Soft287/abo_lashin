import 'package:abolashin/Feature/Auth/profile/manager/profile_cubit.dart';
import 'package:abolashin/Feature/Auth/profile/manager/profile_state.dart';
import 'package:abolashin/core/constans/app_assets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constans/app_colors.dart';
import '../../../../core/sharde/widget/default_button.dart';
import '../../../../core/sharde/widget/text_forn_field.dart';
class ChangePasswordScreen extends StatelessWidget {
   ChangePasswordScreen({super.key});
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight:50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text('change_password'.tr(), style: GoogleFonts.alexandria(


            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white

        )),
        backgroundColor: AppColors.mainAppColor,

        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: Colors.grey,child: Image.asset(AppAssets.changePassword,height: 300,)),
            const SizedBox(height: 20),

            BlocProvider(
              create: (context) => ProfileCubit() ,
              child: BlocConsumer<ProfileCubit,ProfileState>(
                  listener: (context, state) {
                    if (state is ChangePasswordSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text('password_changed_successfully'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,

                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else if (state is ChangePasswordError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('old_password_incorrect'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,

                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },

                builder: (context,state)
                {
                  return Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: Form(

                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            controller: oldPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_old_password'.tr();
                              }
                              value = value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
                                return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
                              });

                              if (value.length < 8) {
                                return 'password_length'.tr();
                              }



                              return null;
                            },
                            subfix: IconButton(
                              onPressed: () {
                                BlocProvider.of<ProfileCubit>(context).togglePasswordOldVisibility()
                                ;
                              },
                              icon: Icon(
                                BlocProvider.of<ProfileCubit>(context).suffixOld,
                                color:AppColors.mainAppColor,
                                size: 25.0,
                              ),
                            ),
                            textInputType: TextInputType.visiblePassword,
                            obscureText:
                            BlocProvider.of<ProfileCubit>(context).isPasswordOldVisible,
                            hintText: 'old_password'.tr(),

                            prefix: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(AppAssets.passwordIcon,),
                            ),
                            fillColor: AppColors.backgroundAppColor,
                            borderColor: AppColors.mainAppColor,
                          ),
                          CustomTextFormField(
                            controller: newPasswordController,
                            subfix: IconButton(
                              onPressed: () {
                                BlocProvider.of<ProfileCubit>(context).togglePasswordNewVisibility()
                                ;
                              },
                              icon: Icon(
                                BlocProvider.of<ProfileCubit>(context).suffixNew,
                                color:AppColors.mainAppColor,
                                size: 25.0,
                              ),
                            ),
                            textInputType: TextInputType.visiblePassword,
                            obscureText:
                            BlocProvider.of<ProfileCubit>(context).isPasswordNewVisible,
                            hintText:'new_password'.tr(),

                            prefix: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(AppAssets.passwordIcon,),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_new_password'.tr();
                              }
                              value = value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
                                return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
                              });

                              if (value.length < 8) {
                                return 'password_length'.tr();
                              }



                              return null;
                            },
                            fillColor: AppColors.backgroundAppColor,
                            borderColor: AppColors.mainAppColor,
                          ),
                          CustomTextFormField(
                            controller: confirmNewPasswordController,
                            hintText: 'confirm_new_password'.tr(),
                            subfix: IconButton(
                              onPressed: () {
                                BlocProvider.of<ProfileCubit>(context).togglePasswordConfirmVisibility()
                                ;
                              },
                              icon: Icon(
                                BlocProvider.of<ProfileCubit>(context).suffixConfirm,
                                color:AppColors.mainAppColor,
                                size: 25.0,
                              ),
                            ),
                            textInputType: TextInputType.visiblePassword,
                            obscureText:
                            BlocProvider.of<ProfileCubit>(context).isPasswordConfirmVisible,
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_confirm_password'.tr();
                            }
                            value = value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
                              return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
                            });

                            if (value != newPasswordController.text) {
                              return 'passwords_do_not_match_new'.tr();
                            }

                            return null;

                          },
                            prefix: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(AppAssets.passwordIcon,),
                            ),
                            fillColor: AppColors.backgroundAppColor,
                            borderColor: AppColors.mainAppColor,
                          ),

                          const SizedBox(height: 20),
                          ConditionalBuilder(
                            condition: state is! ChangePasswordLoading,
                            builder: (context) {
                              return DefaultButton(
                                text: 'change_password'.tr(),
                                function: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<ProfileCubit>(context).changePassword(
                    oldPassword: oldPasswordController.text,
                    newPassword: newPasswordController.text,
                  );
                }


                                },
                                backgroundColor: Colors.transparent,
                                borderRadius: 8,
                                textColor: AppColors.mainAppColor,
                                hasIcon: true,
                                border: Border.all(color: AppColors.secondAppColor, width: 1),
                                icon: Icon(Icons.lock_open, color: AppColors.mainAppColor),
                              );
                            },
                            fallback: (context) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainAppColor,
                                  strokeWidth: 1.0,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },

              ),
            ),
          ],
        ),
      ),

    );
  }
}