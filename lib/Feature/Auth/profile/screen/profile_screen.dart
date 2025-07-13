import 'package:abolashin/Feature/Auth/profile/manager/profile_cubit.dart';
import 'package:abolashin/core/constans/app_colors.dart';
import 'package:abolashin/core/sharde/widget/navigation.dart';
import 'package:abolashin/core/sharde/widget/text_forn_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/default_button.dart';
import '../manager/profile_state.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang')??'ar';
    final currentLocale = context.locale;
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileData() ,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    context.read<ProfileCubit>().isEdite ?Icons.edit: Icons.check  ,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if(!context.read<ProfileCubit>().isEdite)
                      {
                       BlocProvider.of<ProfileCubit>(context).updateUserProfile

                         (
                         firstName: nameController.text,
                           lastName: lastNameController.text,

                           email: organizationController.text,
                           );
                       CacheHelper.putData(
                           key: 'customerName', value:   nameController.text).then((value){

                         customerName=CacheHelper.getData(key: 'customerName');
                         customerName=nameController.text;
                       });
                      }
                    else
                      {
                        context.read<ProfileCubit>().changEdite();
                      }

                  },
                );
              },
            ),
          ],
          title: Text('profile'.tr(), style: GoogleFonts.alexandria(


            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white

          )),
          backgroundColor: AppColors.mainAppColor,

          centerTitle: true,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context,state)
          {
               if(state is GetProfileSuccess)
                 {
                   nameController.text= (currentLocale.languageCode == 'ar')?
                   BlocProvider.of<ProfileCubit>(context).userModel?.arabicName??'':
                   BlocProvider.of<ProfileCubit>(context).userModel?.englishName??'';
                   lastNameController.text= (currentLocale.languageCode == 'ar')?
                   BlocProvider.of<ProfileCubit>(context).userModel?.customerLastName??'':
                   BlocProvider.of<ProfileCubit>(context).userModel?.customerLastName??'';
                   phoneController.text=BlocProvider.of<ProfileCubit>(context).userModel?.customerPhone??'';
                   organizationController.text=BlocProvider.of<ProfileCubit>(context).userModel?.email??'';
                   customerName=CacheHelper.getData(key: 'customerName');
                   customerName=nameController.text;

                 }

               if(state is UpdateDataProfileSuccess)
                 {
                   CacheHelper.putData(
                       key: 'customerName', value:   nameController.text).then((value){

                     customerName=CacheHelper.getData(key: 'customerName');
                     customerName=nameController.text;
                   });


                 }

          },
          builder:
          (context,state)
          {
            return
              Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: nameController,

                        hintText: 'first_name'.tr(),
                        isReadOnly:  context.read<ProfileCubit>().isEdite,
                        prefix: Icon(Icons.person, color: AppColors.mainAppColor),
                        fillColor: AppColors.backgroundAppColor,
                        borderColor: context.read<ProfileCubit>().isEdite ? AppColors.backgroundAppColor: AppColors.mainAppColor,
                      ), CustomTextFormField(
                        controller: lastNameController,

                        hintText: 'last_name'.tr(),
                        isReadOnly:  context.read<ProfileCubit>().isEdite,
                        prefix: Icon(Icons.person, color: AppColors.mainAppColor),
                        fillColor: AppColors.backgroundAppColor,
                        borderColor: context.read<ProfileCubit>().isEdite ? AppColors.backgroundAppColor: AppColors.mainAppColor,
                      ),
                      CustomTextFormField(
                        controller: phoneController,
                        hintText: 'phone_number'.tr(),
                        isReadOnly: true,
                        textInputType: TextInputType.phone,
                        prefix: Icon(Icons.phone, color: AppColors.mainAppColor),
                        fillColor: AppColors.backgroundAppColor,
                        borderColor: AppColors.mainAppColor,
                      ),
                      CustomTextFormField(
                        controller: organizationController,
                        hintText: 'company_name'.tr(), isReadOnly:  context.read<ProfileCubit>().isEdite,
                        prefix: Icon(Icons.business, color: AppColors.mainAppColor),
                        fillColor: AppColors.backgroundAppColor,
                        borderColor: context.read<ProfileCubit>().isEdite ? AppColors.backgroundAppColor: AppColors.mainAppColor,
                      ),


                      const Spacer(),

                      DefaultButton(
                        text: 'change_password'.tr(),
                        function: () {
                        navigato(context, ChangePasswordScreen());
                        },
                        backgroundColor: Colors.transparent,
                        borderRadius: 8,
                        textColor: AppColors.mainAppColor,
                        hasIcon: true,
                        border: Border.all(color:  AppColors.mainAppColor, width: 1),
                        icon: Icon(Icons.lock_open, color: AppColors.mainAppColor),
                      ),

                      const SizedBox(height: 12),

                      BlocConsumer<ProfileCubit,ProfileState>(
                        listener:(context,state)
                        async {
                          if(state is DeleteAccountSuccess)
                          {
                            await CacheHelper.removeData(key: 'customerID');
                            await CacheHelper.removeData(key: 'customerName');
                            customerid = CacheHelper.getData(key: 'customerID');
                            customerName = CacheHelper.getData(key: 'customerName');
                            context.go('/login');

                          }
                        },
                        builder: (context,state)
                        {
                          return DefaultButton(
                            text: 'delete_account'.tr(),
                            function: () {
                              showDialog(

                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,

                                    title: Text('delete_account'.tr(),style: GoogleFonts.alexandria(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color:Colors.black,

                                    ),),
                                    content: Text('confirm_delete_account'.tr(),style: GoogleFonts.alexandria(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color:Colors.black,

                                    ),),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('cancel'.tr() ,style: GoogleFonts.alexandria(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color:Colors.grey,
                                       
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('confirm'.tr(), style:  GoogleFonts.alexandria(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color:AppColors.mainAppColor,

                                        ),),
                                        onPressed: () {

                                          BlocProvider.of<ProfileCubit>(context).deleteAccount();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            backgroundColor: AppColors.mainAppColor,
                            borderRadius: 8,
                            textColor: Colors.white,
                            border: Border.all(color: AppColors.mainAppColor, width: 1),
                            hasIcon: true,
                            icon:const Icon(Icons.delete_forever, color: Colors.white),
                          );
                        },
                        
                      ),
                    ],
                  )

              );
          }

        ),
      ),
    );
  }
}

