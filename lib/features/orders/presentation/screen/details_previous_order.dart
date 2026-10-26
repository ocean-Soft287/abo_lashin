import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:abolashin/features/orders/presentation/manager/previous_order_cubit.dart';
import 'package:abolashin/features/orders/presentation/manager/previous_order_state.dart';
import 'package:abolashin/features/orders/data/model/previous_order_details_model.dart';
import 'package:abolashin/features/orders/data/model/previous_order_model.dart';
import 'package:abolashin/features/orders/presentation/widgets/previous_order_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsPreviousOrder extends StatelessWidget {
  final PreviousOrdersModel? perviousOrderModel;
  const DetailsPreviousOrder({super.key, required this.perviousOrderModel});

  @override
  Widget build(BuildContext context) {
    final order = perviousOrderModel!;

    return Scaffold(
      appBar: AppTopBar(title: 'order_details'.tr()),
      body: BlocProvider(
        create:
            (context) =>
                PreviousOrderCubit()
                  ..getPreviousOrderDetails(orderId: order.orderNo),
        child: BlocBuilder<PreviousOrderCubit, PreviousOrderState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<PreviousOrderCubit>(context);
            final items = cubit.previousOrderDetailsList;

            return ListView(
              padding: EdgeInsets.all(AppSpacing.page),
              children: [
                _OrderHeaderCard(order: order),
                SizedBox(height: AppSpacing.xl),
                AppSectionTitle(
                  title: 'products'.tr(),
                  trailing:
                      items.isEmpty ? null : InfoChip(label: '${items.length}'),
                ),
                SizedBox(height: AppSpacing.md),
                if (state is GetPreviousOrderItemsLoading && items.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.xxl),
                    child: const AppLoader(),
                  )
                else if (state is GetPreviousOrderItemsError && items.isEmpty)
                  SizedBox(
                    height: 320.h,
                    child: ConnectivityRefresh(
                      onReconnect:
                          () => cubit.getPreviousOrderDetails(
                            orderId: order.orderNo,
                          ),
                      child: AppStateView.failure(
                        failure: state.failure,
                        onRetry:
                            () => cubit.getPreviousOrderDetails(
                              orderId: order.orderNo,
                            ),
                      ),
                    ),
                  )
                else if (items.isEmpty)
                  SizedBox(
                    height: 260.h,
                    child: AppStateView.empty(title: 'no_products'.tr()),
                  )
                else
                  for (final item in items) ...[
                    _OrderLineItem(item: item),
                    SizedBox(height: AppSpacing.sm),
                  ],
                SizedBox(height: AppSpacing.md),
                _OrderTotalsCard(order: order),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  final PreviousOrdersModel order;

  const _OrderHeaderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${'order_number'.tr()} ${order.orderNo}',
                  style: GoogleFonts.alexandria(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              OrderStatusChip(received: order.underDeliver),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          OrderInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'order_date'.tr(),
            value: DateFormat('dd/MM/yyyy', 'en').format(order.orderDate),
          ),
          SizedBox(height: AppSpacing.xs),
          OrderInfoRow(
            icon: Icons.location_on_outlined,
            label: 'delivery_address'.tr(),
            value: order.orderAddress,
          ),
        ],
      ),
    );
  }
}

class _OrderLineItem extends StatelessWidget {
  final PreviousOrderDetailsModel item;

  const _OrderLineItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final unit = isArabic ? item.unitArName : item.unitEnName;
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 72.w,
            height: 72.h,
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: context.colors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: ProductTileImage(url: item.productImage),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? item.productArName : item.productEnName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    InfoChip(label: '${'quantity'.tr()}: ${item.quantity}'),
                    if (unit.trim().isNotEmpty)
                      InfoChip(icon: Icons.scale_outlined, label: unit),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  formatPriceWithCurrency(item.price),
                  style: GoogleFonts.alexandria(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTotalsCard extends StatelessWidget {
  final PreviousOrdersModel order;

  const _OrderTotalsCard({required this.order});

  Widget _row(
    String label,
    num value,
    BuildContext context, {
    bool emphasize = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.alexandria(
                fontSize: (emphasize ? 14 : 13).sp,
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w400,
                color:
                    emphasize
                        ? context.colors.textPrimary
                        : context.colors.textSecondary,
              ),
            ),
          ),
          Text(
            formatPriceWithCurrency(value),
            style: GoogleFonts.alexandria(
              fontSize: (emphasize ? 17 : 13).sp,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              color:
                  emphasize
                      ? context.colors.primary
                      : context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          _row('total_price'.tr(), order.finalValue, context, emphasize: true),
        ],
      ),
    );
  }
}
