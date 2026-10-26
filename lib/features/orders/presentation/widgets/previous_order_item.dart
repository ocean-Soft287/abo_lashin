import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/orders/data/model/previous_order_model.dart';
import 'package:abolashin/features/orders/presentation/screen/details_previous_order.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderStatusChip extends StatelessWidget {
  final bool received;

  const OrderStatusChip({super.key, required this.received});

  @override
  Widget build(BuildContext context) {
    return InfoChip(
      icon: received ? Icons.check_circle_rounded : Icons.schedule_rounded,
      label: received ? 'received'.tr() : 'not_delivered'.tr(),
      background:
          received ? context.colors.successSoft : context.colors.dangerSoft,
      foreground: received ? context.colors.success : context.colors.danger,
    );
  }
}

class OrderInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const OrderInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.r, color: context.colors.textHint),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.alexandria(
            fontSize: 12.sp,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.alexandria(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class PreviousOrderItem extends StatelessWidget {
  final PreviousOrdersModel previousOrder;

  const PreviousOrderItem({super.key, required this.previousOrder});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        context.pushScreen(
          DetailsPreviousOrder(perviousOrderModel: previousOrder),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: context.colors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: context.colors.primary,
                  size: 22.r,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  '${'order_number'.tr()} ${previousOrder.orderNo}',
                  style: GoogleFonts.alexandria(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              OrderStatusChip(received: previousOrder.underDeliver),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          OrderInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'order_date'.tr(),
            value: DateFormat(
              'dd/MM/yyyy',
              'en',
            ).format(previousOrder.orderDate),
          ),
          SizedBox(height: AppSpacing.xs),
          OrderInfoRow(
            icon: Icons.location_on_outlined,
            label: 'delivery_address'.tr(),
            value: previousOrder.orderAddress,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: const Divider(),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'total_price'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              Text(
                formatPriceWithCurrency(previousOrder.finalValue),
                style: GoogleFonts.alexandria(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: context.colors.primary,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right_rounded, color: context.colors.textHint),
            ],
          ),
        ],
      ),
    );
  }
}
