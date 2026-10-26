import 'package:abolashin/features/auth/presentation/widgets/show_account_exists_warning.dart';
import 'package:abolashin/features/addresses/presentation/manager/add_address_state.dart';
import 'package:abolashin/core/constants/app_assets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:abolashin/features/auth/presentation/manager/register_state.dart';
import 'package:abolashin/features/auth/presentation/screen/login_screen.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/widget/widgets/default_button.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/core/widget/widgets/app_text_form_field.dart';
import 'package:abolashin/features/addresses/presentation/manager/add_address_cubit.dart';
import 'package:abolashin/features/addresses/data/model/area_model.dart';
import 'package:abolashin/features/addresses/data/model/governorate_model.dart';
import 'package:abolashin/features/auth/presentation/widgets/auth_header.dart';
import 'package:abolashin/features/auth/presentation/widgets/custom_dialog.dart';
import 'package:abolashin/features/auth/presentation/manager/register_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  void dispose() {
    companyNameController.dispose();
    phoneNumberController.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    nameAddressController.dispose();
    detailsAddressController.dispose();
    super.dispose();
  }

  Widget _svgIcon(String asset) => Padding(
    padding: EdgeInsets.all(12.0.r),
    child: SvgPicture.asset(
      asset,
      colorFilter: ColorFilter.mode(
        context.colors.textSecondary,
        BlendMode.srcIn,
      ),
    ),
  );

  ButtonStyleData _dropdownButtonStyle(BuildContext context) => ButtonStyleData(
    height: 52.h,
    width: MediaQuery.sizeOf(context).width,
    padding: EdgeInsetsDirectional.only(start: 16.w, end: 8.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.md),
      color: context.colors.surfaceMuted,
    ),
  );

  DropdownStyleData get _dropdownMenuStyle => DropdownStyleData(
    maxHeight: 260.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.md),
      color: context.colors.surface,
    ),
  );

  IconStyleData get _dropdownIconStyle => IconStyleData(
    icon: Icon(
      Icons.keyboard_arrow_down_rounded,
      color: context.colors.primary,
    ),
    iconSize: 24.r,
  );

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return BlocProvider(
      create: (context) => RegisterViewCubit(),
      child: BlocConsumer<RegisterViewCubit, RegisterViewState>(
        listener: (context, state) {
          if (state is RegisterViewStateSuccess) {
            context.pushScreen(const LoginScreen());
          }

          if (state is RegisterViewStateError) {
            if (state.error == "This customer exists.") {
              showAccountExistsDialog(context);
            } else {
              customDialog(title: 'account_failed'.tr(), context: context);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: context.colors.scaffold,
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      title: 'register_new_account'.tr(),
                      subtitle: 'register_subtitle'.tr(),
                      showBack: true,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        AppSpacing.xl,
                        AppSpacing.page,
                        AppSpacing.xxl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthSectionLabel(
                                  text: 'account_info'.tr(),
                                  icon: Icons.person_outline_rounded,
                                ),
                                CustomTextFormField(
                                  prefix: _svgIcon(AppAssets.userNameIcon),
                                  hintText: 'first_name'.tr(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_first_name'.tr();
                                    }

                                    return null;
                                  },
                                  controller: firstNameController,
                                ),
                                CustomTextFormField(
                                  prefix: _svgIcon(AppAssets.userNameIcon),
                                  hintText: 'last_name'.tr(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_first_name'.tr();
                                    }

                                    return null;
                                  },
                                  controller: lastNameController,
                                ),
                                CustomTextFormField(
                                  prefix: _svgIcon(AppAssets.gmailIcon),
                                  hintText: 'institution_name'.tr(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_institution_name'
                                          .tr();
                                    }

                                    return null;
                                  },
                                  controller: companyNameController,
                                ),
                                CustomTextFormField(
                                  prefix: _svgIcon('assets/icons/phone.svg'),
                                  hintText: 'mobile'.tr(),
                                  textInputType: TextInputType.phone,
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
                                  controller: phoneNumberController,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),

                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthSectionLabel(
                                  text: 'password'.tr(),
                                  icon: Icons.lock_outline_rounded,
                                ),
                                CustomTextFormField(
                                  prefix: _svgIcon(AppAssets.passwordIcon),
                                  hintText: 'password'.tr(),
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

                                    if (value.length < 8) {
                                      return 'password_length'.tr();
                                    }

                                    return null;
                                  },
                                  controller: passwordController,
                                  subfix: IconButton(
                                    onPressed: () {
                                      BlocProvider.of<RegisterViewCubit>(
                                        context,
                                      ).changIconPassword();
                                    },
                                    icon: Icon(
                                      BlocProvider.of<RegisterViewCubit>(
                                        context,
                                      ).subfix,
                                      color: context.colors.primary,
                                      size: 22.0.r,
                                    ),
                                  ),
                                  textInputType: TextInputType.visiblePassword,
                                  obscureText:
                                      BlocProvider.of<RegisterViewCubit>(
                                        context,
                                      ).isPassword,
                                ),
                                CustomTextFormField(
                                  prefix: _svgIcon(AppAssets.passwordIcon),
                                  hintText: 'confirm_password'.tr(),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_confirm_password'
                                          .tr();
                                    }
                                    value = value.replaceAllMapped(
                                      RegExp(r'[٠-٩]'),
                                      (match) {
                                        return (match.group(0)!.codeUnitAt(0) -
                                                0x0660)
                                            .toString();
                                      },
                                    );

                                    if (value != passwordController.text) {
                                      return 'passwords_do_not_match'.tr();
                                    }

                                    return null;
                                  },
                                  subfix: IconButton(
                                    onPressed: () {
                                      BlocProvider.of<RegisterViewCubit>(
                                        context,
                                      ).changIconPasswordConfirm();
                                    },
                                    icon: Icon(
                                      BlocProvider.of<RegisterViewCubit>(
                                        context,
                                      ).subfixConfirm,
                                      color: context.colors.primary,
                                      size: 22.0.r,
                                    ),
                                  ),
                                  textInputType: TextInputType.visiblePassword,
                                  obscureText:
                                      BlocProvider.of<RegisterViewCubit>(
                                        context,
                                      ).isPasswordConfirm,
                                  controller: confirmPasswordController,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),

                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthSectionLabel(
                                  text: 'delivery_address_section'.tr(),
                                  icon: Icons.location_on_outlined,
                                ),
                                CustomTextFormField(
                                  prefix: const Icon(Icons.bookmark_outline),
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
                                  prefix: const Icon(Icons.home_work_outlined),
                                  hintText: 'address_details'.tr(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_address_details'
                                          .tr();
                                    }

                                    return null;
                                  },
                                  controller: detailsAddressController,
                                ),
                                SizedBox(height: AppSpacing.sm),
                                BlocBuilder<AddAddressCubit, AddAddressState>(
                                  builder: (context, state) {
                                    return DropdownButton2<GovernorateModel>(
                                      isExpanded: true,
                                      underline: const SizedBox.shrink(),
                                      hint: Text(
                                        'select_governorate'.tr(),
                                        style: GoogleFonts.alexandria(
                                          fontSize: 13.sp,
                                          color: context.colors.textHint,
                                        ),
                                      ),
                                      items:
                                          BlocProvider.of<AddAddressCubit>(
                                                context,
                                              ).governoratesList
                                              .map(
                                                (
                                                  governorate,
                                                ) => DropdownMenuItem<
                                                  GovernorateModel
                                                >(
                                                  value: governorate,
                                                  child: Text(
                                                    (currentLocale
                                                                .languageCode ==
                                                            'ar')
                                                        ? governorate
                                                            .governorateName
                                                        : governorate
                                                            .governorateEName,
                                                    style:
                                                        GoogleFonts.alexandria(
                                                          fontSize: 14.sp,
                                                        ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      value:
                                          BlocProvider.of<AddAddressCubit>(
                                            context,
                                          ).selectedGovernorate,
                                      onChanged: (GovernorateModel? value) {
                                        if (value != null) {
                                          BlocProvider.of<AddAddressCubit>(
                                            context,
                                          ).updateSelectedGovernorate(value);
                                        }
                                      },
                                      buttonStyleData: _dropdownButtonStyle(
                                        context,
                                      ),
                                      dropdownStyleData: _dropdownMenuStyle,
                                      menuItemStyleData: MenuItemStyleData(
                                        height: 44.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                      ),
                                      iconStyleData: _dropdownIconStyle,
                                    );
                                  },
                                ),
                                SizedBox(height: AppSpacing.md),
                                BlocBuilder<AddAddressCubit, AddAddressState>(
                                  builder: (context, state) {
                                    return DropdownButton2<AreaModel>(
                                      isExpanded: true,
                                      underline: const SizedBox.shrink(),
                                      hint: Text(
                                        'select_area'.tr(),
                                        style: GoogleFonts.alexandria(
                                          fontSize: 13.sp,
                                          color: context.colors.textHint,
                                        ),
                                      ),
                                      items:
                                          BlocProvider.of<AddAddressCubit>(
                                                context,
                                              ).areaModelList
                                              .toSet()
                                              .map(
                                                (areaModel) => DropdownMenuItem<
                                                  AreaModel
                                                >(
                                                  value: areaModel,
                                                  child: Text(
                                                    (currentLocale
                                                                .languageCode ==
                                                            'ar')
                                                        ? areaModel.districtName
                                                                ?.toString() ??
                                                            ''
                                                        : areaModel
                                                                .districtEName
                                                                ?.toString() ??
                                                            '',
                                                    style:
                                                        GoogleFonts.alexandria(
                                                          fontSize: 14.sp,
                                                        ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      value:
                                          BlocProvider.of<AddAddressCubit>(
                                            context,
                                          ).areaModel,
                                      onChanged: (AreaModel? value) {
                                        if (value != null) {
                                          BlocProvider.of<AddAddressCubit>(
                                            context,
                                          ).updateSelectedArea(value);
                                        }
                                      },
                                      buttonStyleData: _dropdownButtonStyle(
                                        context,
                                      ),
                                      dropdownStyleData: _dropdownMenuStyle,
                                      menuItemStyleData: MenuItemStyleData(
                                        height: 44.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                      ),
                                      iconStyleData: _dropdownIconStyle,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.xxl),
                          ConditionalBuilder(
                            condition: state is! RegisterViewStateLoading,
                            builder: (context) {
                              return DefaultButton(
                                text: 'register'.tr(),
                                hasIcon: true,
                                icon: Icon(
                                  Icons.person_add_alt_1_rounded,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                                function: () {
                                  if (keyForm.currentState!.validate()) {
                                    final addressCubit =
                                        BlocProvider.of<AddAddressCubit>(
                                          context,
                                        );
                                    if (addressCubit.selectedGovernorate ==
                                        null) {
                                      customDialog(
                                        title: 'select_governorate'.tr(),
                                        context: context,
                                      );
                                      return;
                                    }
                                    if (addressCubit.areaModel == null) {
                                      customDialog(
                                        title: 'select_area'.tr(),
                                        context: context,
                                      );
                                      return;
                                    }
                                    BlocProvider.of<RegisterViewCubit>(
                                      context,
                                    ).registerUser(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      companyName: companyNameController.text,

                                      password: passwordController.text,
                                      phone: phoneNumberController.text,
                                      nameAddress: nameAddressController.text,
                                      detailsAddress:
                                          detailsAddressController.text,
                                      districtName:
                                          addressCubit.areaModel!.districtName,

                                      regionName:
                                          addressCubit
                                              .selectedGovernorate!
                                              .governorateName,
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
                          SizedBox(height: AppSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'have_account'.tr(),
                                  style: GoogleFonts.alexandria(
                                    fontSize: 13.sp,
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.maybePop(context),
                                child: Text('login'.tr()),
                              ),
                            ],
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
