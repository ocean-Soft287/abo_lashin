import 'package:abolashin/Feature/Auth/login/screen/widget/custom_dialog.dart';
import 'package:abolashin/Feature/Auth/login/screen/widget/wave_background_painter.dart';
import 'package:abolashin/core/sharde/widget/navigation.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constans/app_assets.dart';
import '../../../../core/constans/app_colors.dart';
import '../../../../core/constans/constants.dart';
import '../../../../core/network/local/cachehelper.dart';
import '../../../../core/sharde/widget/default_button.dart';
import '../../../../core/sharde/widget/text_forn_field.dart';
import '../../../main/Home/home_screen.dart';
import '../../Register/screen/register_screen.dart';
import '../manager/login_view_cubit.dart';
import '../manager/login_view_state.dart';
class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var keyForm = GlobalKey<FormState>();

   final phoneController = TextEditingController();

   final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>LoginViewCubit(),
      child: BlocConsumer<LoginViewCubit,LoginViewState>(
        listener: (context,state) async {






      if(state is LoginViewStateSuccess)
      {

        if (state.dataUser!=null) {
            CacheHelper.saveData(
                key: 'customerPhone', value: state.dataUser.customerPhone);
            CacheHelper.saveData(
                key: 'customerName', value: state.dataUser.arabicName);
          CacheHelper.saveData(
              key: 'customerID', value: state.dataUser.customerId)
              .then((value) {
            customerid = CacheHelper.getData(key: 'customerID');
            customerPhone=CacheHelper.getData(key: 'customerPhone');
            customerName=CacheHelper.getData(key: 'customerName');
            Fluttertoast.showToast(
                msg: 'login_success'.tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          //  context.go('/home');

        navigatofinsh(context, const HomeScreen(), false);
          });

        }


      }

      if (state is LoginViewStateError) {

        customDialog(title:  'login_failed_subtitle'.tr(),context: context);




      }


        },

        builder: (context,state){

          LoginViewCubit loginViewCubit=BlocProvider.of(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(child:
          SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: CustomPaint(
          painter: WaveBackgroundPainter(),

          child: SingleChildScrollView(
            child: Form(
              key: keyForm,
              child: Column(
                children: [
                 30.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 60),
                    child: SvgPicture.asset(AppAssets.logoLogin,width: MediaQuery.sizeOf(context).width,),
                  ),
                  50.verticalSpace,
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
                        Text(
                          'login'.tr(),
                          style: GoogleFonts.alexandria(
                            textStyle: TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.mainAppColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width*.7,
                      child: CustomTextFormField(
                        hintText: 'phone_with_country_code'.tr(),
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
                        controller: phoneController,
                        textInputType: TextInputType.phone,
                      ),

                    ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width*.7,
                          child: CustomTextFormField(hintText: 'password'.tr(),
                            validator: (value) {

                              if (value == null || value.isEmpty) {
                                return 'please_enter_password'.tr();
                              }
                              value = value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
                                return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
                              });



                              return null;
                            },
                            controller: passwordController,
                            subfix: IconButton(
                              onPressed: () {
                                BlocProvider.of<LoginViewCubit>(context)
                                    .changIconPassword();
                              },
                              icon: Icon(
                                BlocProvider.of<LoginViewCubit>(context).subfix,
                                color:AppColors.mainAppColor,
                                size: 25.0,
                              ),
                            ),
                            textInputType: TextInputType.visiblePassword,
                            obscureText:
                            BlocProvider.of<LoginViewCubit>(context).isPassword,



                          ),
                        ),
                        const SizedBox(height: 20,),
                        SizedBox( width: MediaQuery.sizeOf(context).width*.5,child:
                        ConditionalBuilder(
                          condition:state is !LoginViewStateLoading  ,
                          builder:(context){
                            return      DefaultButton(text: 'login'.tr(),function: (){
                         if (keyForm.currentState!.validate()) {
                       loginViewCubit.userLogin(customerPhone: phoneController.text, password: passwordController.text);

                         }

                              // final decryptedText = decrypt("zj7WgPwCj6wp8cbQxNNpZ5FJooQc/quvXeq5Sc30twPMeejq5nZsLpExze8oQYRqZPhsEmOKfzcITj3nnaYq5NELQBKAmhXLGrK0zJfJsbiirVccbv4Mxp3KxOSCYW2PhD4rDoUOwiJLPeeboV8Xi1jbaOpWYmI3/eOoDayq762pbBBpBLyqE3BW5KvVMELJ", privateKey, publicKey);
                              //
                              //
                              //
                              //
                       //  navigato(context, HomeScreen());

                            },);
                          } ,
                          fallback:(context){
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.mainAppColor,
                                strokeWidth: 1.0,
                              ),
                            );

                          } ,

                        ),)

                      ],
                    ),
                  ),
                  15.verticalSpace,
                  Text(
                    'no_account'.tr(),
                    style: GoogleFonts.alexandria(
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w200,
                        color:Colors.white,
                      ),
                    ),
                  ),
                  6.verticalSpace,
                  SizedBox( width: MediaQuery.sizeOf(context).width*.7,child: DefaultButton(text: 'register_new_account'.tr(),function: (){

                    navigato(context, const RegisterScreen());


                  },backgroundColor: AppColors.secondAppColor,))


                ],
              ),
            ),
          )))

            ),
          );
        },

      ),
    );
  }
}

