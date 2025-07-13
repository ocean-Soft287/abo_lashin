import 'package:abolashin/Feature/main/menu/PreviousOrders/screen/widget/step_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constans/app_assets.dart';
import '../../../../../../core/constans/app_colors.dart';
import '../../../../../../core/sharde/widget/navigation.dart';
import '../../manager/previous_order_cubit.dart';
import '../details_previous_order.dart';
class OrderTrackingCard extends StatelessWidget {
  final PreviousOrderCubit orderTrackingCubit;

  const OrderTrackingCard({super.key, required this.orderTrackingCubit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orderTrackingCubit.orderTrackingDetails.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            navigato(
              context,
              DetailsPreviousOrder(perviousOrderModel: orderTrackingCubit.orderTrackingDetails[index]),
            );
          },
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 4),
                            ),
                            TextSpan(
                              text: '${orderTrackingCubit.orderTrackingDetails[index].orderNo}',
                              style: GoogleFonts.alexandria(
                                fontSize: 14.sp,
                                color: AppColors.mainAppColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${orderTrackingCubit.orderTrackingDetails[index].finalValue}',
                              style: GoogleFonts.alexandria(
                                fontSize: 14.sp,
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 4),
                            ),
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
                    ],
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'order_date'.tr(),
                          style: GoogleFonts.alexandria(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 8),
                        ),
                        TextSpan(
                          text: DateFormat('dd MMM yyyy', 'ar').format(
                            orderTrackingCubit.orderTrackingDetails[index].orderDate,
                          ),
                          style: GoogleFonts.alexandria(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  StepItem(
                    title: 'order_received'.tr(),
                    subtitle: 'order_received_desc'.tr(),
                    icon: Icons.check_circle,
                    isActive: orderTrackingCubit.orderTrackingDetails[index].sendingOrder,
                    image: AppAssets.orderDeliveredIcon,
                    divider: true,
                  ),
                  const SizedBox(height: 5),
                  StepItem(
                    title: 'order_confirmed'.tr(),
                    subtitle: 'order_confirmed_desc'.tr(),
                    icon: Icons.check_circle,
                    isActive: orderTrackingCubit.orderTrackingDetails[index].startDeliver,
                    image: AppAssets.orderInPreparationIcon,
                    divider: true,
                  ),
                  const SizedBox(height: 5),
                  StepItem(
                    title: 'order_in_preparation'.tr(),
                    subtitle: 'order_in_preparation_desc'.tr(),
                    icon: Icons.check_circle,
                    isActive: orderTrackingCubit.orderTrackingDetails[index].prepare,
                    image: AppAssets.orderDeliveredIcon,
                    divider: true,
                  ),
                  const SizedBox(height: 5),
                  StepItem(
                    title: 'order_in_transit'.tr(),
                    subtitle: 'order_in_transit_desc'.tr(),
                    icon: Icons.check_circle,
                    isActive: orderTrackingCubit.orderTrackingDetails[index].underDeliver,
                    image: AppAssets.OrderInTransitIcon,
                    divider: true,
                  ),
                  const SizedBox(height: 5),
                  StepItem(
                    title: 'order_delivered'.tr(),
                    subtitle: 'order_delivered_desc'.tr(),
                    icon: Icons.check_circle,
                    isActive: orderTrackingCubit.orderTrackingDetails[index].delivered,
                    image: AppAssets.orderDeliveredIcon,
                    divider: false,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
