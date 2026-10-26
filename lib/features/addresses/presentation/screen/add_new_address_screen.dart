import 'package:abolashin/features/addresses/presentation/manager/add_address_state.dart';
import 'package:abolashin/features/addresses/data/model/area_model.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/widget/widgets/default_button.dart';
import 'package:abolashin/core/widget/widgets/app_text_form_field.dart';
import 'package:abolashin/features/auth/presentation/widgets/custom_dialog.dart';
import 'package:abolashin/features/addresses/presentation/manager/add_address_cubit.dart';
import 'package:abolashin/features/addresses/data/model/governorate_model.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewAddress extends StatefulWidget {
  final bool isSavedAddressPage;
  const AddNewAddress({super.key, this.isSavedAddressPage = false});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final keyForm = GlobalKey<FormState>();
  final nameAddressController = TextEditingController();
  final detailsAddressController = TextEditingController();

  @override
  void dispose() {
    nameAddressController.dispose();
    detailsAddressController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!keyForm.currentState!.validate()) return;
    final cubit = BlocProvider.of<AddAddressCubit>(context);
    if (!await context.ensureSignedIn()) return;
    if (!context.mounted) return;
    if (cubit.selectedGovernorate == null) {
      _showSnack(context, 'select_governorate'.tr());
      return;
    }
    if (cubit.areaModel == null) {
      _showSnack(context, 'select_area'.tr());
      return;
    }
    cubit.addNewAddress(
      nameAddress: nameAddressController.text,
      detailsAddress: detailsAddressController.text,
      districtName: cubit.areaModel!.districtName,
      regionName: cubit.selectedGovernorate!.governorateName,
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: context.colors.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Scaffold(
      appBar: AppTopBar(
        title: 'add_address'.tr(),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocProvider(
        create:
            (context) =>
                AddAddressCubit()
                  ..getGovernorates()
                  ..getArea(),
        child: BlocConsumer<AddAddressCubit, AddAddressState>(
          listener: (context, state) {
            if (state is AddNewAddressSuccess) {
              if (state.data.contains("This customer doesn't exist.")) {
                customDialog(title: 'address_not_added'.tr(), context: context);
              } else {
                showCustomSnackBar(context, 'address_added_successfully'.tr());
                context.read<AddOrderCubit>().getAllAddress();

                Navigator.pop(context);
                if (!widget.isSavedAddressPage) {
                  Navigator.pop(context);
                  BlocProvider.of<HomeCubit>(
                    context,
                  ).changeSelectIndexBottom(index: 2);
                }
              }
            }

            if (state is AddNewAddressError) {
              customDialog(title: 'address_not_added'.tr(), context: context);
            }
          },
          builder: (context, state) {
            final cubit = BlocProvider.of<AddAddressCubit>(context);
            if (cubit.governoratesList.isEmpty) {
              if (cubit.governoratesLoading) return const AppLoader();
              if (cubit.governoratesFailure != null) {
                return ConnectivityRefresh(
                  onReconnect: cubit.getGovernorates,
                  child: AppStateView.failure(
                    failure: cubit.governoratesFailure,
                    onRetry: cubit.getGovernorates,
                  ),
                );
              }
            }
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.xl,
                AppSpacing.page,
                AppSpacing.xxl,
              ),
              child: Form(
                key: keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  color: context.colors.secondarySoft,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_location_alt_rounded,
                                  color: context.colors.secondary,
                                ),
                              ),
                              SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AppSectionTitle(
                                  title: 'add_new_address'.tr(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.lg),
                          _FieldLabel('address_name'.tr()),
                          CustomTextFormField(
                            hintText: 'address_name'.tr(),
                            paddingN: 6,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please_enter_address_name'.tr();
                              }
                              return null;
                            },
                            controller: nameAddressController,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          _FieldLabel('address_details'.tr()),
                          CustomTextFormField(
                            hintText: 'address_details'.tr(),
                            paddingN: 6,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please_enter_address_details'.tr();
                              }
                              return null;
                            },
                            controller: detailsAddressController,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          _FieldLabel('select_governorate'.tr()),
                          SizedBox(height: 6.h),
                          _AppDropdown<GovernorateModel>(
                            hint: 'select_governorate'.tr(),
                            value: cubit.selectedGovernorate,
                            items: cubit.governoratesList,
                            labelOf:
                                (governorate) =>
                                    (currentLocale.languageCode == 'ar')
                                        ? governorate.governorateName
                                        : governorate.governorateEName,
                            onChanged: (GovernorateModel? value) {
                              if (value != null) {
                                cubit.updateSelectedGovernorate(value);
                              }
                            },
                          ),
                          SizedBox(height: AppSpacing.lg),
                          _FieldLabel('select_area'.tr()),
                          SizedBox(height: 6.h),
                          _AppDropdown<AreaModel>(
                            hint: 'select_area'.tr(),
                            value: cubit.areaModel,
                            items: cubit.areaModelList.toSet().toList(),
                            labelOf:
                                (areaModel) =>
                                    (currentLocale.languageCode == 'ar')
                                        ? areaModel.districtName?.toString() ??
                                            ''
                                        : areaModel.districtEName?.toString() ??
                                            '',
                            onChanged: (AreaModel? value) {
                              if (value != null) {
                                cubit.updateSelectedArea(value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxl),
                    if (state is AddNewAddressLoading)
                      SizedBox(height: 50.h, child: const AppLoader())
                    else
                      DefaultButton(
                        text: 'add_address'.tr(),
                        hasIcon: true,
                        icon: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                        ),
                        function: () => _submit(context),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.alexandria(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: context.colors.textPrimary,
      ),
    );
  }
}

class _AppDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  const _AppDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.alexandria(
      fontSize: 14.sp,
      color: context.colors.textPrimary,
    );
    return DropdownButton2<T>(
      isExpanded: true,
      underline: const SizedBox.shrink(),
      hint: Text(
        hint,
        style: GoogleFonts.alexandria(
          fontSize: 13.sp,
          color: context.colors.textHint,
        ),
      ),
      items:
          items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    labelOf(item),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
              )
              .toList(),
      value: value,
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        height: 52.h,
        padding: EdgeInsetsDirectional.only(start: 4.w, end: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: context.colors.surfaceMuted,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 280.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: context.colors.surface,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: context.colors.primary,
        ),
        iconSize: 24.r,
      ),
    );
  }
}

void showCustomSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: GoogleFonts.alexandria(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: context.colors.onSuccess,
      ),
    ),
    backgroundColor: context.colors.success,
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
