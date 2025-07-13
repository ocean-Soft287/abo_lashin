import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constans/app_colors.dart';
import '../../../Add Order/manager/add_order_cubit.dart';

class AddressItemComponent extends StatelessWidget {
  final AddOrderCubit addOrderCubit;
  final int index;
  bool isSavedAddressPage = false;
  AddressItemComponent({
    this.isSavedAddressPage = false,
    super.key,
    required this.addOrderCubit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addOrderCubit.changeSelectedAddress(index);
        if (!isSavedAddressPage) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color:
              (addOrderCubit.selectAddress == index)
                  ? const Color(0xffB5B7D0)
                  : Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: AppColors.mainAppColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              addOrderCubit.allAddressList[index].addressNotes ?? '',
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.mainAppColor,
              ),
            ),
            Text(
              addOrderCubit.allAddressList[index].arabicName ?? '',
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.mainAppColor,
              ),
            ),
            Text(
              addOrderCubit.allAddressList[index].customerPhone ?? '',
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.mainAppColor,
              ),
            ),
            Text(
              addOrderCubit.allAddressList[index].address ?? '',
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.mainAppColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
