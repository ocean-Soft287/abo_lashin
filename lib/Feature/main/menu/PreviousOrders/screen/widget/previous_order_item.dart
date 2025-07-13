import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constans/app_colors.dart';
import '../../../../../../core/sharde/widget/navigation.dart';
import '../../model/previous_order_model.dart';
import '../details_previous_order.dart';
class PreviousOrderItem extends StatelessWidget {
  final PreviousOrdersModel previousOrder;

  const PreviousOrderItem({super.key, required this.previousOrder});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigato(
          context,
          DetailsPreviousOrder(perviousOrderModel: previousOrder),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'order_number'.tr(),
                        style: GoogleFonts.alexandria(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 4)),
                      TextSpan(
                        text: '${previousOrder.orderNo ?? ''}',
                        style: GoogleFonts.alexandria(
                          fontSize: 14.sp,
                          color: AppColors.mainAppColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  previousOrder.underDeliver ? 'received'.tr() : 'not_delivered'.tr(),
                  style: GoogleFonts.alexandria(
                    color: previousOrder.underDeliver ? const Color(0xff52A756) : Colors.red,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'order_date'.tr(),
                    style: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)),
                  TextSpan(
                    text: DateFormat('dd/MM/yyyy', 'en').format(previousOrder.orderDate),
                    style: GoogleFonts.alexandria(
                      fontSize: 14.sp,
                      color: AppColors.mainAppColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'delivery_address'.tr(),
                    style: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)),
                  TextSpan(
                    text: previousOrder.orderAddress ?? '',
                    style: GoogleFonts.alexandria(
                      fontSize: 12.sp,
                      color: AppColors.mainAppColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Divider(height: 1, color: Color(0xff979797)),
            5.verticalSpace,
            Align(
              alignment: Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'total_price'.tr(),
                      style: GoogleFonts.alexandria(
                        fontSize: 11.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: previousOrder.finalValue.toString() ?? '',
                      style: GoogleFonts.alexandria(
                        fontSize: 16.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: 'currency'.tr(),
                      style: GoogleFonts.alexandria(
                        fontSize: 12.sp,
                        color: AppColors.mainAppColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}