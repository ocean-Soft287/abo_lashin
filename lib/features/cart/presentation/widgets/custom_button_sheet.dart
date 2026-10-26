import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_state.dart';
import 'package:abolashin/features/addresses/presentation/screen/add_new_address_screen.dart';
import 'package:abolashin/features/addresses/presentation/widgets/address_item_component.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonSheet extends StatelessWidget {
  final AddOrderCubit addOrderCubit;
  const CustomButtonSheet({super.key, required this.addOrderCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddOrderCubit, AddOrderState>(
      bloc: addOrderCubit,
      builder: (context, state) {
        final addresses = addOrderCubit.allAddressList;
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.page,
              0,
              AppSpacing.page,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'choose_address'.tr(),
                        style: GoogleFonts.alexandria(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip:
                          MaterialLocalizations.of(context).closeButtonTooltip,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                if (addresses.isEmpty && addOrderCubit.addressesLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: const AppLoader(),
                  )
                else if (addresses.isEmpty &&
                    addOrderCubit.addressesFailure != null)
                  ConnectivityRefresh(
                    onReconnect: addOrderCubit.getAllAddress,
                    child: AppStateView.failure(
                      failure: addOrderCubit.addressesFailure,
                      onRetry: addOrderCubit.getAllAddress,
                    ),
                  ),
                if (addresses.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'existing_address'.tr(),
                    style: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        return AddressItemComponent(
                          index: index,
                          addOrderCubit: addOrderCubit,
                        );
                      },
                      separatorBuilder:
                          (context, index) => SizedBox(height: AppSpacing.md),
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: () => context.pushScreen(const AddNewAddress()),
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: Text('add_new_address'.tr()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
