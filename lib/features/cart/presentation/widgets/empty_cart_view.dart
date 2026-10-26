import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(AppAssets.cartEmpty, width: 220.w, repeat: false),
            SizedBox(height: AppSpacing.lg),
            Text(
              'cart_empty_title'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.alexandria(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'cart_empty_message'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.alexandria(
                fontSize: 13.sp,
                height: 1.5,
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed:
                  () => BlocProvider.of<HomeCubit>(
                    context,
                  ).changeSelectIndexBottom(index: 0),
              icon: const Icon(Icons.storefront_outlined),
              label: Text('start_shopping'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
