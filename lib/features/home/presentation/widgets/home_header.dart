import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_state.dart';
import 'package:abolashin/features/search/presentation/screen/search_screen.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/features/addresses/presentation/screen/saved_addresses_screen.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16.w, topInset + 12, 16.w, 16.h),
            decoration: BoxDecoration(
              color: context.colors.primarySoft,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.xl),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.asset(AppAssets.logo, width: 48.w, height: 48.h),
                ),
                SizedBox(width: 10.w),
                const Expanded(child: _AddressPill()),
                SizedBox(width: 10.w),
                const _CartButton(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: const _SearchField(),
          ),
        ],
      ),
    );
  }
}

class _AddressPill extends StatelessWidget {
  const _AddressPill();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.pushScreen(const SavedAddressesScreen()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          child: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 20.r,
                color: context.colors.secondary,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'deliver_to'.tr(),
                      style: GoogleFonts.alexandria(
                        fontSize: 10.sp,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    BlocBuilder<AddOrderCubit, AddOrderState>(
                      builder: (context, state) {
                        final cubit = context.read<AddOrderCubit>();
                        final list = cubit.allAddressList;
                        final index = cubit.selectAddress;
                        final text =
                            (index >= 0 && index < list.length)
                                ? [
                                      list[index].address,
                                      list[index].addressNotes,
                                    ]
                                    .where((e) => (e ?? '').trim().isNotEmpty)
                                    .join(' - ')
                                : '';
                        return Text(
                          text.isEmpty ? 'your_address'.tr() : text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.alexandria(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: context.colors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20.r,
                color: context.colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCubit, CartState, int>(
      selector: (_) => context.read<CartCubit>().cartItems.length,
      builder: (context, count) {
        return IconButton(
          tooltip: 'cart'.tr(),
          style: IconButton.styleFrom(
            backgroundColor: context.colors.brand,
            minimumSize: Size(48.w, 48.h),
          ),
          onPressed:
              () => BlocProvider.of<HomeCubit>(
                context,
              ).changeSelectIndexBottom(index: 2),
          icon: Badge(
            isLabelVisible: count > 0,
            backgroundColor: context.colors.brandYellow,
            textColor: context.colors.textPrimary,
            label: Text('$count'),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      shape: StadiumBorder(side: BorderSide(color: context.colors.border)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.pushScreen(const SearchScreen()),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: context.colors.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'search_products_hint'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      color: context.colors.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
