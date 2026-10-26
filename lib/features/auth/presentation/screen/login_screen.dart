import 'package:abolashin/features/auth/presentation/widgets/custom_dialog.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/auth/presentation/widgets/session_actions.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/widget/widgets/default_button.dart';
import 'package:abolashin/core/widget/widgets/app_text_form_field.dart';
import 'package:abolashin/features/home/presentation/screen/home_screen.dart';
import 'package:abolashin/features/auth/presentation/screen/register_screen.dart';
import 'package:abolashin/features/auth/presentation/manager/login_cubit.dart';
import 'package:abolashin/features/auth/presentation/manager/login_state.dart';
import 'package:abolashin/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginViewCubit(),
      child: BlocConsumer<LoginViewCubit, LoginViewState>(
        listener: (context, state) async {
          if (state is LoginViewStateSuccess) {
            Fluttertoast.showToast(
              msg: 'login_success'.tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: context.colors.success,
              textColor: context.colors.onSuccess,
              fontSize: 16.0.sp,
            );
            reloadSessionData(context);
            context.replaceAllWith(const HomeScreen());
          }

          if (state is LoginViewGuestSuccess) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.replaceAllWith(const HomeScreen());
            }
          }

          if (state is LoginViewStateError) {
            final failure = state.failure;
            final rejected = failure == null || failure is ValidationFailure;
            customDialog(
              title:
                  rejected
                      ? 'login_failed_subtitle'.tr()
                      : failure.messageKey.tr(),
              context: context,
            );
          }
        },

        builder: (context, state) {
          LoginViewCubit loginViewCubit = BlocProvider.of(context);
          return Scaffold(
            backgroundColor: context.colors.scaffold,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      title: 'login'.tr(),
                      subtitle: 'login_subtitle'.tr(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        AppSpacing.xxl,
                        AppSpacing.page,
                        AppSpacing.xxl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppCard(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.xl,
                              AppSpacing.lg,
                              AppSpacing.xl,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _FieldLabel('mobile'.tr()),
                                CustomTextFormField(
                                  hintText: 'phone_with_country_code'.tr(),
                                  prefix: const Icon(
                                    Icons.phone_iphone_rounded,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_phone'.tr();
                                    }

                                    value = value.replaceAllMapped(
                                      RegExp(r'[٠-٩]'),
                                      (match) {
                                        return (match.group(0)!.codeUnitAt(0) -
                                                0x0660)
                                            .toString();
                                      },
                                    );

                                    final phoneRegExp = RegExp(
                                      r"^0[125][0-9]{9}$",
                                    );
                                    if (!phoneRegExp.hasMatch(value)) {
                                      return 'please_enter_valid_phone'.tr();
                                    }

                                    return null;
                                  },
                                  controller: phoneController,
                                  textInputType: TextInputType.phone,
                                ),
                                SizedBox(height: AppSpacing.sm),
                                _FieldLabel('password'.tr()),
                                CustomTextFormField(
                                  hintText: 'password'.tr(),
                                  prefix: const Icon(
                                    Icons.lock_outline_rounded,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_password'.tr();
                                    }
                                    value = value.replaceAllMapped(
                                      RegExp(r'[٠-٩]'),
                                      (match) {
                                        return (match.group(0)!.codeUnitAt(0) -
                                                0x0660)
                                            .toString();
                                      },
                                    );

                                    return null;
                                  },
                                  controller: passwordController,
                                  subfix: IconButton(
                                    onPressed: () {
                                      BlocProvider.of<LoginViewCubit>(
                                        context,
                                      ).changIconPassword();
                                    },
                                    icon: Icon(
                                      BlocProvider.of<LoginViewCubit>(
                                        context,
                                      ).subfix,
                                      color: context.colors.primary,
                                      size: 22.0.r,
                                    ),
                                  ),
                                  textInputType: TextInputType.visiblePassword,
                                  obscureText:
                                      BlocProvider.of<LoginViewCubit>(
                                        context,
                                      ).isPassword,
                                ),
                                SizedBox(height: AppSpacing.xl),
                                ConditionalBuilder(
                                  condition: state is! LoginViewStateLoading,
                                  builder: (context) {
                                    return DefaultButton(
                                      text: 'login'.tr(),
                                      hasIcon: true,
                                      icon: Icon(
                                        Icons.login_rounded,
                                        color: Colors.white,
                                        size: 20.r,
                                      ),
                                      function: () {
                                        if (keyForm.currentState!.validate()) {
                                          loginViewCubit.userLogin(
                                            customerPhone: phoneController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                    );
                                  },
                                  fallback:
                                      (context) => SizedBox(
                                        height: 50.h,
                                        child: const AppLoader(),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.xxl),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                  ),
                                  child: Text(
                                    'no_account'.tr(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.alexandria(
                                      fontSize: 13.sp,
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md),
                          OutlinedButton.icon(
                            onPressed:
                                () =>
                                    context.pushScreen(const RegisterScreen()),
                            icon: const Icon(Icons.person_add_alt_1_rounded),
                            label: Text('register_new_account'.tr()),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          TextButton.icon(
                            onPressed:
                                state is LoginViewStateLoading
                                    ? null
                                    : loginViewCubit.continueAsGuest,
                            icon: const Icon(Icons.storefront_outlined),
                            label: Text('continue_as_guest'.tr()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 4.w),
      child: Text(
        text,
        style: GoogleFonts.alexandria(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }
}
