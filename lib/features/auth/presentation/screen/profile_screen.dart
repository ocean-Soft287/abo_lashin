import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/features/auth/presentation/manager/profile_cubit.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/core/widget/widgets/app_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/features/auth/presentation/widgets/session_actions.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/auth/presentation/manager/profile_state.dart';
import 'package:abolashin/features/auth/presentation/screen/change_password_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    organizationController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _onEditPressed(BuildContext context) {
    if (!context.read<ProfileCubit>().isEdite) {
      BlocProvider.of<ProfileCubit>(context).updateUserProfile(
        firstName: nameController.text,
        lastName: lastNameController.text,

        email: organizationController.text,
      );
    } else {
      context.read<ProfileCubit>().changEdite();
    }
  }

  void _confirmDeleteAccount(BuildContext context) {
    final profileCubit = BlocProvider.of<ProfileCubit>(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: context.colors.dangerSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_forever_rounded,
              color: context.colors.danger,
              size: 30.r,
            ),
          ),
          title: Text('delete_account'.tr(), textAlign: TextAlign.center),
          content: Text(
            'confirm_delete_account'.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.alexandria(
              fontSize: 13.sp,
              height: 1.5,
              color: context.colors.textSecondary,
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text('cancel'.tr()),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colors.danger,
                    ),
                    onPressed: () => profileCubit.deleteAccount(),
                    child: Text('confirm'.tr()),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileData(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state is GetProfileSuccess) {
            nameController.text =
                (currentLocale.languageCode == 'ar')
                    ? BlocProvider.of<ProfileCubit>(
                          context,
                        ).userModel?.arabicName ??
                        ''
                    : BlocProvider.of<ProfileCubit>(
                          context,
                        ).userModel?.englishName ??
                        '';
            lastNameController.text =
                BlocProvider.of<ProfileCubit>(
                  context,
                ).userModel?.customerLastName ??
                '';
            phoneController.text =
                BlocProvider.of<ProfileCubit>(
                  context,
                ).userModel?.customerPhone ??
                '';
            organizationController.text =
                BlocProvider.of<ProfileCubit>(context).userModel?.email ?? '';
          }

          if (state is UpdateDataProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  (state.failure?.messageKey ?? 'error_unknown').tr(),
                ),
                backgroundColor: context.colors.danger,
              ),
            );
          }

          if (state is DeleteAccountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  (state.failure?.messageKey ?? 'error_unknown').tr(),
                ),
                backgroundColor: context.colors.danger,
              ),
            );
          }

          if (state is DeleteAccountSuccess) {
            await signOutAndReset(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final readOnly = cubit.isEdite;
          final focusColor =
              readOnly ? context.colors.scaffold : context.colors.primary;

          return Scaffold(
            appBar: AppTopBar(
              title: 'profile'.tr(),
              actions: [
                IconButton(
                  tooltip: readOnly ? 'edit'.tr() : 'save'.tr(),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        readOnly
                            ? context.colors.surface
                            : context.colors.primary,
                  ),
                  icon: Icon(
                    readOnly ? Icons.edit_outlined : Icons.check_rounded,
                    color:
                        readOnly
                            ? context.colors.primary
                            : context.colors.onPrimary,
                  ),
                  onPressed: () => _onEditPressed(context),
                ),
                SizedBox(width: AppSpacing.xs),
              ],
            ),
            body:
                state is GetProfileLoading && cubit.userModel == null
                    ? const AppLoader()
                    : state is GetProfileError && cubit.userModel == null
                    ? ConnectivityRefresh(
                      onReconnect: cubit.getProfileData,
                      child: AppStateView.failure(
                        failure: state.failure,
                        onRetry: cubit.getProfileData,
                      ),
                    )
                    : ListView(
                      padding: EdgeInsets.all(AppSpacing.page),
                      children: [
                        _ProfileSummary(
                          name: nameController.text,
                          phone: phoneController.text,
                        ),
                        SizedBox(height: AppSpacing.lg),
                        AppCard(
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            AppSpacing.sm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormField(
                                controller: nameController,
                                hintText: 'first_name'.tr(),
                                isReadOnly: readOnly,
                                prefix: const Icon(
                                  Icons.person_outline_rounded,
                                ),
                                borderColor: focusColor,
                              ),
                              CustomTextFormField(
                                controller: lastNameController,
                                hintText: 'last_name'.tr(),
                                isReadOnly: readOnly,
                                prefix: const Icon(
                                  Icons.person_outline_rounded,
                                ),
                                borderColor: focusColor,
                              ),
                              CustomTextFormField(
                                controller: phoneController,
                                hintText: 'phone_number'.tr(),
                                isReadOnly: true,
                                textInputType: TextInputType.phone,
                                prefix: const Icon(Icons.phone_outlined),
                                borderColor: context.colors.primary,
                              ),
                              CustomTextFormField(
                                controller: organizationController,
                                hintText: 'company_name'.tr(),
                                isReadOnly: readOnly,
                                prefix: const Icon(Icons.business_outlined),
                                borderColor: focusColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        AppCard(
                          padding: EdgeInsets.all(AppSpacing.xs),
                          child: Column(
                            children: [
                              AppMenuTile(
                                icon: Icons.lock_outline_rounded,
                                title: 'change_password'.tr(),
                                onTap:
                                    () => context.pushScreen(
                                      const ChangePasswordScreen(),
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                  start: 64.w,
                                  end: AppSpacing.md,
                                ),
                                child: const Divider(),
                              ),
                              AppMenuTile(
                                icon: Icons.delete_outline_rounded,
                                title: 'delete_account'.tr(),
                                color: context.colors.danger,
                                trailing:
                                    state is DeleteAccountLoading
                                        ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                        )
                                        : const SizedBox.shrink(),
                                onTap: () => _confirmDeleteAccount(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
          );
        },
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  final String name;
  final String phone;

  const _ProfileSummary({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64.w,
          height: 64.h,
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: context.colors.brandYellow,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? 'profile'.tr() : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.alexandria(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              if (phone.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  phone,
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
