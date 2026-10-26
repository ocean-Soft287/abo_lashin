import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/auth/presentation/manager/profile_cubit.dart';
import 'package:abolashin/features/auth/presentation/manager/profile_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/widget/widgets/default_button.dart';
import 'package:abolashin/core/widget/widgets/app_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  String _normalizeDigits(String value) =>
      value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
        return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
      });

  Widget _visibilityToggle(VoidCallback onPressed, IconData icon) =>
      IconButton(onPressed: onPressed, icon: Icon(icon));

  void _showSnack(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: 'change_password'.tr()),
      body: BlocProvider(
        create: (context) => ProfileCubit(),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              _showSnack(
                context,
                'password_changed_successfully'.tr(),
                context.colors.success,
              );
            } else if (state is ChangePasswordError) {
              final failure = state.failure;
              _showSnack(
                context,
                failure == null || failure is ValidationFailure
                    ? 'old_password_incorrect'.tr()
                    : failure.messageKey.tr(),
                context.colors.danger,
              );
            }
          },
          builder: (context, state) {
            final cubit = BlocProvider.of<ProfileCubit>(context);
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.page),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  SizedBox(height: AppSpacing.md),
                  Container(
                    width: 88.w,
                    height: 88.h,
                    decoration: BoxDecoration(
                      color: context.colors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 42.r,
                      color: context.colors.primary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'change_password'.tr(),
                    style: GoogleFonts.alexandria(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  AppCard(
                    padding: EdgeInsets.all(AppSpacing.lg),
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
                              value = _normalizeDigits(value);
                              if (value.length < 8) {
                                return 'password_length'.tr();
                              }
                              return null;
                            },
                            subfix: _visibilityToggle(
                              cubit.togglePasswordOldVisibility,
                              cubit.suffixOld,
                            ),
                            textInputType: TextInputType.visiblePassword,
                            obscureText: cubit.isPasswordOldVisible,
                            hintText: 'old_password'.tr(),
                            prefix: const Icon(Icons.lock_outline_rounded),
                          ),
                          CustomTextFormField(
                            controller: newPasswordController,
                            subfix: _visibilityToggle(
                              cubit.togglePasswordNewVisibility,
                              cubit.suffixNew,
                            ),
                            textInputType: TextInputType.visiblePassword,
                            obscureText: cubit.isPasswordNewVisible,
                            hintText: 'new_password'.tr(),
                            prefix: const Icon(Icons.lock_outline_rounded),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_new_password'.tr();
                              }
                              value = _normalizeDigits(value);
                              if (value.length < 8) {
                                return 'password_length'.tr();
                              }
                              return null;
                            },
                          ),
                          CustomTextFormField(
                            controller: confirmNewPasswordController,
                            hintText: 'confirm_new_password'.tr(),
                            subfix: _visibilityToggle(
                              cubit.togglePasswordConfirmVisibility,
                              cubit.suffixConfirm,
                            ),
                            textInputType: TextInputType.visiblePassword,
                            obscureText: cubit.isPasswordConfirmVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please_enter_confirm_password'.tr();
                              }
                              value = _normalizeDigits(value);
                              if (value != newPasswordController.text) {
                                return 'passwords_do_not_match_new'.tr();
                              }
                              return null;
                            },
                            prefix: const Icon(Icons.lock_outline_rounded),
                          ),
                          SizedBox(height: AppSpacing.lg),
                          state is ChangePasswordLoading
                              ? SizedBox(height: 50.h, child: const AppLoader())
                              : DefaultButton(
                                text: 'change_password'.tr(),
                                hasIcon: true,
                                icon: const Icon(
                                  Icons.lock_open_rounded,
                                  color: Colors.white,
                                ),
                                function: () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.changePassword(
                                      oldPassword: oldPasswordController.text,
                                      newPassword: newPasswordController.text,
                                    );
                                  }
                                },
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
