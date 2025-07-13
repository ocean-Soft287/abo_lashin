import 'package:abolashin/Feature/Auth/Register/screen/widget/show_account_exists_warning.dart';
import 'package:abolashin/Feature/main/Add_New_Address/manager/add_address_state.dart';
import 'package:abolashin/core/constans/app_assets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:abolashin/Feature/Auth/Register/manager/register_view_state.dart';
import 'package:abolashin/Feature/Auth/login/screen/login_screen.dart';
import 'package:abolashin/core/constans/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/default_button.dart';
import '../../../../core/sharde/widget/navigation.dart';
import '../../../../core/sharde/widget/text_forn_field.dart';
import '../../../main/Add_New_Address/manager/add_address_cubit.dart';
import '../../../main/Add_New_Address/model/area_model.dart';
import '../../../main/Add_New_Address/model/governorate_model.dart';
import '../../login/screen/widget/custom_dialog.dart';
import '../../login/screen/widget/wave_background_painter.dart';
import '../manager/register_view_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var keyForm = GlobalKey<FormState>();

  final companyNameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController nameAddressController = TextEditingController();

  TextEditingController detailsAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
    final currentLocale = context.locale;
    return BlocProvider(
      create: (context)=>RegisterViewCubit(),
      child: BlocConsumer<RegisterViewCubit,RegisterViewState>(
        listener: (context,state){
          if(state is RegisterViewStateSuccess)
          {
          //  GoRouter.of(context).push('/login');
         navigato(context, const LoginScreen());
          }

          if (state is RegisterViewStateError) {

            if(state.error=="This customer exists.")
              {
                showAccountExistsDialog(context);
              }
            else
              {
                customDialog(title:  'account_failed'.tr(),context: context);


              }


          }

        },
        builder: (context,state){


          return  Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SafeArea(child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      child: CustomPaint(
                      painter: WaveBackgroundPainter(color: AppColors.secondAppColor),

                      child: SingleChildScrollView(
                child:Form(
                  key: keyForm,
                  child: Column(

                    children: [
                      60.verticalSpace,
                      Center(
                        child: Text( 'register_new_account'.tr(),style:  GoogleFonts.alexandria(
                            color:const Color(0xff5C5C5C),
                            fontSize:25.sp,
                            fontWeight: FontWeight.w400,


                        ),),
                      ),
                      30.verticalSpace,

                      Container(

                        width: MediaQuery.sizeOf(context).width*.8,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(width: MediaQuery.sizeOf(context).width*.7,
                              child: CustomTextFormField(
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(AppAssets.userNameIcon,),
                                ),
                                hintText: 'first_name'.tr(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'please_enter_first_name'.tr();
                                  }
                                  //

                                  // final nameRegExp = RegExp(r"^[a-zA-Z0-9\u0621-\u064A]+$");
                                  //
                                  // if (!nameRegExp.hasMatch(value)) {
                                  //   return 'please_enter_valid_first_name'.tr();
                                  // }

                                  return null;
                                },
                                controller:firstNameController,
                              ),
                            ),
                            SizedBox(width: MediaQuery.sizeOf(context).width*.7,
                              child: CustomTextFormField(
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(AppAssets.userNameIcon,),
                                ),
                                hintText: 'last_name'.tr(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'please_enter_first_name'.tr();
                                  }

                                  // // Regular expression to match Arabic, English letters, and numbers
                                  // final nameRegExp = RegExp(r"^[a-zA-Z0-9\u0621-\u064A]+$");
                                  //
                                  // if (!nameRegExp.hasMatch(value)) {
                                  //   return 'please_enter_valid_first_name'.tr();
                                  // }

                                  return null;
                                },
                                controller:lastNameController,
                              ),
                            ),


                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*.7,
                              child: CustomTextFormField(
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(AppAssets.gmailIcon,),
                                ),
                                hintText: 'institution_name'.tr(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'please_enter_institution_name'.tr();
                                  }





                                  return null;
                                },
                                controller: companyNameController, // ربط الحقل بالـ controller
                              ),
                            ),


                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*.7,
                              child: CustomTextFormField(
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset('assets/icons/phone.svg',),
                                ),
                                hintText: 'mobile'.tr(), textInputType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'please_enter_phone'.tr();
                                  }


                                  value = value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
                                    return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
                                  });


                                  final phoneRegExp = RegExp(r"^0[125][0-9]{9}$");
                                  if (!phoneRegExp.hasMatch(value)) {
                                    return 'please_enter_valid_phone'.tr();
                                  }

                                  return null;
                                },
                                controller: phoneNumberController,
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*.7,
                              child: CustomTextFormField(
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(AppAssets.passwordIcon,),
                                ),
                                hintText: 'password'.tr(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'please_enter_password'.tr();
                                  }
                                  value = value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
                                    return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
                                  });

                                  if (value.length < 8) {
                                    return 'password_length'.tr();
                                  }



                                  return null;
                                },
                                controller: passwordController,
                                subfix: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<RegisterViewCubit>(context)
                                        .changIconPassword();
                                  },
                                  icon: Icon(
                                    BlocProvider.of<RegisterViewCubit>(context).subfix,
                                    color:AppColors.mainAppColor,
                                    size: 25.0,
                                  ),
                                ),
                                textInputType: TextInputType.visiblePassword,
                                obscureText:
                                BlocProvider.of<RegisterViewCubit>(context).isPassword,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*.7,
                              child: CustomTextFormField(


                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(AppAssets.passwordIcon,),
                                ),
                                hintText: 'confirm_password'.tr(),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'please_enter_confirm_password'.tr();
                                  }
                                  value = value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
                                    return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
                                  });

                                  if (value != passwordController.text) {
                                    return 'passwords_do_not_match'.tr();
                                  }

                                  return null;

                                },
                                subfix: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<RegisterViewCubit>(context)
                                        .changIconPasswordConfirm();
                                  },
                                  icon: Icon(
                                    BlocProvider.of<RegisterViewCubit>(context).subfixConfirm,
                                    color:AppColors.mainAppColor,
                                    size: 25.0,
                                  ),
                                ),
                                textInputType: TextInputType.visiblePassword,
                                obscureText:
                                BlocProvider.of<RegisterViewCubit>(context).isPasswordConfirm,
                                controller: confirmPasswordController, // ربط الحقل بالـ controller
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*.7,
                              child: CustomTextFormField(


                                hintText: 'address_name'.tr(),
                                validator: (value) {

                                  if (value == null || value.isEmpty) {
                                    return 'please_enter_address_name'.tr();
                                  }




                                  return null;
                                },
                                controller: nameAddressController,




                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*.7,
                              child: CustomTextFormField(


                                hintText: 'address_details'.tr(),
                                validator: (value) {

                                  if (value == null || value.isEmpty) {
                                    return 'please_enter_address_details'.tr();
                                  }




                                  return null;
                                },
                                controller: detailsAddressController,




                              ),
                            ),




                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*.7,
                              child: BlocBuilder<AddAddressCubit,AddAddressState>(
                                builder: (context,state)
                                {
                                  return  DropdownButton2<GovernorateModel>(
                                    isExpanded: true,
                                    hint: Text(
                                      'select_governorate'.tr(),
                                      style: GoogleFonts.alexandria(fontSize: 12.sp, color: AppColors.mainAppColor),
                                    ),
                                    items: BlocProvider.of<AddAddressCubit>(context).governoratesList // Assuming governoratesList is your List<GovernorateModel>
                                        .map((governorate) => DropdownMenuItem<GovernorateModel>(
                                      value: governorate,
                                      child: Text(
                                        (currentLocale.languageCode == 'ar')?
                                        governorate.governorateName:governorate.governorateEName,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ))
                                        .toList(),
                                    value:BlocProvider.of<AddAddressCubit>(context).selectedGovernorate, // Assuming selectedGovernorate is a GovernorateModel object or GovernorateID
                                    onChanged: (GovernorateModel? value) {
                                      if (value != null) {
                                        BlocProvider.of<AddAddressCubit>(context).updateSelectedGovernorate(value);
                                      //  BlocProvider.of<AddAddressCubit>(context).getArea(governorateId: BlocProvider.of<AddAddressCubit>(context).selectedGovernorate!.governorateID);
                                      }
                                    },
                                    buttonStyleData: ButtonStyleData(


                                      height: 50,
                                      width: MediaQuery.sizeOf(context).width,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),

                                      decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.transparent),
                                        color:  const Color(0xffEEEEEE),
                                      ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(

                                      maxHeight: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height:40,
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(Icons.arrow_drop_down, color:AppColors.mainAppColor),
                                      iconSize: 24,
                                    ),
                                  );
                                },

                              ),
                            ),
                            10.verticalSpace,

                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*.7,
                              child: BlocBuilder<AddAddressCubit,AddAddressState>(
                                builder: (context,state)
                                {

                                  return DropdownButton2<AreaModel>(
                                    isExpanded: true,
                                    hint: Text(
                                      'select_area'.tr(),
                                      style: GoogleFonts.alexandria(fontSize: 12.sp, color: AppColors.mainAppColor),
                                    ),
                                    items: BlocProvider.of<AddAddressCubit>(context)
                                        .areaModelList
                                        .toSet() // إزالة العناصر المكررة إذا وجدت
                                        .map(
                                          (areaModel) => DropdownMenuItem<AreaModel>(
                                        value: areaModel,
                                        child: Text(
                                          (currentLocale.languageCode == 'ar')
                                              ? areaModel.districtName?.toString() ?? ''
                                              : areaModel.districtEName?.toString() ?? '',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                        .toList(),
                                    value: BlocProvider.of<AddAddressCubit>(context).areaModel,
                                    onChanged: (AreaModel? value) {
                                      if (value != null) {
                                        BlocProvider.of<AddAddressCubit>(context).updateSelectedArea(value);
                                      }
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      width: MediaQuery.sizeOf(context).width,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.transparent),
                                        color:  const Color(0xffEEEEEE),
                                      ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(Icons.arrow_drop_down, color: AppColors.mainAppColor),
                                      iconSize: 24,
                                    ),
                                  );
                                },

                              ),
                            ),
                            const SizedBox(height: 50,),
                            SizedBox( width: MediaQuery.sizeOf(context).width*.5,child:   ConditionalBuilder(
                              condition:state is !RegisterViewStateLoading ,
                              builder:(context){
                                return  DefaultButton(text: 'register'.tr(),function: (){

                                  if (keyForm.currentState!.validate()) {
                                    BlocProvider.of<RegisterViewCubit>(context).registerUser
                                      (firstName: firstNameController.text,
                                        lastName:lastNameController.text,
                                        companyName:companyNameController.text,

                                        password:passwordController.text,
                                        phone: phoneNumberController.text,
                                        nameAddress: nameAddressController.text,
                                        detailsAddress: detailsAddressController.text,
                                        districtName:
                                        BlocProvider
                                            .of<AddAddressCubit>(context)
                                            .areaModel!
                                            .districtName
                                        ,

                                        regionName:  BlocProvider
                                            .of<AddAddressCubit>(context)
                                            .selectedGovernorate!
                                            .governorateName,

                                    );
                                  }


                                },backgroundColor: AppColors.mainAppColor);
                              } ,
                              fallback:(context){
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.mainAppColor,
                                    strokeWidth: 1.0,
                                  ),
                                );

                              } ,

                            ),),

                          ],
                        ),
                      ),





                    ],

                  ),
                ),
              ),
            ),
                        ),
            )
          )
            ;
        },

      ),

    );
  }
}
