import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/extention/context_extention.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressItemComponent extends StatelessWidget {
  final AddOrderCubit addOrderCubit;
  final int index;
  final bool isSavedAddressPage;
  const AddressItemComponent({
    this.isSavedAddressPage = false,
    super.key,
    required this.addOrderCubit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final address = addOrderCubit.allAddressList[index];
    final selected = addOrderCubit.selectAddress == index;
    final primary = context.colors.primary;

    TextStyle style({double size = 12, FontWeight weight = FontWeight.w400}) =>
        GoogleFonts.alexandria(fontSize: size.sp, fontWeight: weight);

    final title =
        (address.addressNotes ?? '').trim().isNotEmpty
            ? address.addressNotes!
            : (address.address ?? '');

    return Material(
      color: selected ? context.colors.primarySoft : context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: selected ? primary : context.colors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          addOrderCubit.changeSelectedAddress(index);
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color:
                      selected
                          ? context.colors.surface
                          : context.colors.secondarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: context.colors.secondary,
                  size: 22.r,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: style(size: 14, weight: FontWeight.w700),
                    ),
                    if ((address.address ?? '').trim().isNotEmpty &&
                        title != address.address) ...[
                      SizedBox(height: 2.h),
                      Text(address.address!, style: style()),
                    ],
                    if (address.arabicName.trim().isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      _Line(
                        icon: Icons.person_outline_rounded,
                        text: address.arabicName,
                        style: style(),
                      ),
                    ],
                    if (address.customerPhone.trim().isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      _Line(
                        icon: Icons.phone_outlined,
                        text: address.customerPhone,
                        style: style(),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? primary : context.colors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle style;
  final TextDirection? textDirection;

  const _Line({
    required this.icon,
    required this.text,
    required this.style,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15.r, color: context.colors.textHint),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            text,
            textDirection: textDirection,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}
