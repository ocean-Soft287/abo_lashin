import 'package:abolashin/Feature/main/Add%20Order/manager/add_order_state.dart';
import 'package:abolashin/Feature/main/Add_New_Address/manager/add_address_state.dart';
import 'package:abolashin/Feature/main/Add_New_Address/model/area_model.dart';
import 'package:abolashin/Feature/main/Home/manager/home_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../../core/constans/app_colors.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/default_button.dart';
import '../../../../core/sharde/widget/text_forn_field.dart';
import '../../../Auth/login/screen/widget/custom_dialog.dart';
import '../manager/add_address_cubit.dart';
import '../model/governorate_model.dart';
class AddNewAddress extends StatelessWidget {
  var keyForm = GlobalKey<FormState>();
  final nameAddressController = TextEditingController();
  final detailsAddressController = TextEditingController();
  bool isSavedAddressPage = false;
  AddNewAddress({super.key,this.isSavedAddressPage=false});

  @override
  Widget build(BuildContext context) {
    currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
    final currentLocale = context.locale;
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Text('add_address'.tr(),




          style: GoogleFonts.alexandria(
            textStyle: TextStyle(
              fontSize: 16.sp,

              fontWeight: FontWeight.w400,
              color:const Color(0xff181818),
            ),
          ),),
        scrolledUnderElevation: 0,
        leading:     GestureDetector(
          onTap: () {
            Navigator.pop(context); Navigator.pop(context);
          },
          child: Icon(Icons.close, color: AppColors.mainAppColor),
        ),
      ),
      body: BlocProvider(
        create: (context)=>AddAddressCubit()..getGovernorates()..getArea(),
        child: BlocConsumer<AddAddressCubit,AddAddressState>(
          listener: (context,state)
          {
            if(state is AddNewAddressSuccess)
            {

              if (state.data.contains("This customer doesn't exist.")) {
                customDialog(title:  'address_not_added'.tr(),context: context,);




                  //  context.go('/home');

                  // navigatofinsh(context, HomeScreen(), false);


              }
              else
                {
                  showCustomSnackBar(context,'address_added_successfully'.tr(),);


                  Navigator.pop(context);
                  if(!isSavedAddressPage)
                    {
                      Navigator.pop(context);
                      BlocProvider.of<HomeCubit>(context).changeSelectIndexBottom(index: 2);
                    }

                  }


            }

            if (state is AddNewAddressError) {

              customDialog(title:  'address_not_added'.tr(),context: context,);




            }

          },
          builder:(context,state)
          {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: keyForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      CustomTextFormField(

                        fillColor: Colors.white,
                        hintText: 'address_name'.tr(),
                        validator: (value) {

                          if (value == null || value.isEmpty) {
                            return 'please_enter_address_name'.tr();
                          }




                          return null;
                        },
                        controller: nameAddressController,




                      ),
                      CustomTextFormField(

                        fillColor: Colors.white,
                        hintText: 'address_details'.tr(),
                        validator: (value) {

                          if (value == null || value.isEmpty) {
                            return 'please_enter_address_details'.tr();
                          }




                          return null;
                        },
                        controller: detailsAddressController,




                      ),



                      Text(
                        'select_governorate'.tr(),
                        style: GoogleFonts.alexandria(
                          textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color:Colors.black,
                          ),
                        ),
                      ),
                      4.verticalSpace,
                      DropdownButton2<GovernorateModel>(
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
                          }
                        },
                        buttonStyleData: ButtonStyleData(


                          height: 50,
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.transparent),
                            color: Colors.white,
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
                      ),
                  10.verticalSpace,
                      Text(
                        'select_area'.tr(),
                        style: GoogleFonts.alexandria(
                          textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color:Colors.black,
                          ),
                        ),
                      ),
                      4.verticalSpace,
                  DropdownButton2<AreaModel>(
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
                        color: Colors.white,
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
                  ),


                  40.verticalSpace,

                      ConditionalBuilder(
                        condition:state is !AddOrderLoading  ,
                        builder:(context){
                          return        DefaultButton(text: 'add_address'.tr(),function: (){


          if (keyForm.currentState!.validate()) {
            BlocProvider.of<AddAddressCubit>(context).
            addNewAddress(
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

                          },backgroundColor: AppColors.mainAppColor,);

                        } ,
                        fallback:(context){
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainAppColor,
                              strokeWidth: 1.0,
                            ),
                          );

                        } ,

                      ),


                    ],
                  ),
                ),
              ),
            );
          },

        ),
      ),
    );
  }
}

void showCustomSnackBar(BuildContext context, String message, ) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    margin: const EdgeInsets.all(2),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}