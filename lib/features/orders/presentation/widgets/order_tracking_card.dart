import 'package:abolashin/features/orders/presentation/widgets/step_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/constants/app_assets.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/orders/presentation/manager/previous_order_cubit.dart';
import 'package:abolashin/features/orders/presentation/screen/details_previous_order.dart';
import 'package:abolashin/features/orders/presentation/widgets/previous_order_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTrackingCard extends StatelessWidget {
  final PreviousOrderCubit orderTrackingCubit;

  const OrderTrackingCard({super.key, required this.orderTrackingCubit});

  @override
  Widget build(BuildContext context) {
    final orders = orderTrackingCubit.orderTrackingDetails;
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.xxl,
      ),
      itemCount: orders.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final order = orders[index];
        return AppCard(
          onTap: () {
            context.pushScreen(DetailsPreviousOrder(perviousOrderModel: order));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'order_number'.tr()} ${order.orderNo}',
                          style: GoogleFonts.alexandria(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                            context.locale.languageCode,
                          ).format(order.orderDate),
                          style: GoogleFonts.alexandria(
                            fontSize: 12.sp,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatPriceWithCurrency(order.finalValue),
                    style: GoogleFonts.alexandria(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              OrderStatusChip(received: order.underDeliver),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: const Divider(),
              ),
              StepItem(
                title: 'order_received'.tr(),
                subtitle: 'order_received_desc'.tr(),
                icon: Icons.check_circle,
                isActive: order.sendingOrder,
                image: AppAssets.orderDeliveredIcon,
                divider: true,
              ),
              StepItem(
                title: 'order_confirmed'.tr(),
                subtitle: 'order_confirmed_desc'.tr(),
                icon: Icons.check_circle,
                isActive: order.startDeliver,
                image: AppAssets.orderInPreparationIcon,
                divider: true,
              ),
              StepItem(
                title: 'order_in_preparation'.tr(),
                subtitle: 'order_in_preparation_desc'.tr(),
                icon: Icons.check_circle,
                isActive: order.prepare,
                image: AppAssets.orderDeliveredIcon,
                divider: true,
              ),
              StepItem(
                title: 'order_in_transit'.tr(),
                subtitle: 'order_in_transit_desc'.tr(),
                icon: Icons.check_circle,
                isActive: order.underDeliver,
                image: AppAssets.OrderInTransitIcon,
                divider: true,
              ),
              StepItem(
                title: 'order_delivered'.tr(),
                subtitle: 'order_delivered_desc'.tr(),
                icon: Icons.check_circle,
                isActive: order.delivered,
                image: AppAssets.orderDeliveredIcon,
                divider: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
