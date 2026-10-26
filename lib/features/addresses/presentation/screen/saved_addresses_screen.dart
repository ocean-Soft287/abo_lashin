import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/route/routing.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_state.dart';
import 'package:abolashin/features/addresses/presentation/screen/add_new_address_screen.dart';
import 'package:abolashin/features/addresses/presentation/widgets/address_item_component.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  Future<void> _addAddress(BuildContext context) async {
    if (!await context.ensureSignedIn()) return;
    if (!context.mounted) return;
    context.pushScreen(const AddNewAddress(isSavedAddressPage: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: 'saved_addresses'.tr()),
      body: BlocBuilder<AddOrderCubit, AddOrderState>(
        builder: (context, state) {
          final cubit = BlocProvider.of<AddOrderCubit>(context);
          if (!context.isSignedIn) {
            return AppStateView(
              icon: Icons.lock_outline_rounded,
              title: 'login_required_title'.tr(),
              message: 'login_required_message'.tr(),
              actionLabel: 'login_now'.tr(),
              actionIcon: Icons.login_rounded,
              onAction: () => Navigator.of(context).pushNamed(AppRoute.login),
            );
          }
          if (cubit.allAddressList.isEmpty) {
            if (cubit.addressesLoading) return const AppLoader();
            if (cubit.addressesFailure != null) {
              return ConnectivityRefresh(
                onReconnect: cubit.getAllAddress,
                child: AppStateView.failure(
                  failure: cubit.addressesFailure,
                  onRetry: cubit.getAllAddress,
                ),
              );
            }
            return AppStateView.empty(
              icon: Icons.location_off_outlined,
              title: 'no_saved_addresses'.tr(),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.lg,
              AppSpacing.page,
              96.h,
            ),
            itemCount: cubit.allAddressList.length,
            itemBuilder: (context, index) {
              return AddressItemComponent(
                isSavedAddressPage: true,
                index: index,
                addOrderCubit: cubit,
              );
            },
            separatorBuilder:
                (context, index) => SizedBox(height: AppSpacing.md),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        onPressed: () => _addAddress(context),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text('add_new_address'.tr()),
      ),
    );
  }
}
