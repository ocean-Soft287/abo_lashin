import 'package:abolashin/features/home/presentation/screen/home_screen.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/widget/widgets/default_button.dart';

import 'package:abolashin/features/cart/data/model/cart_item_model.dart'
    as cart;
import 'package:abolashin/features/checkout/data/model/order_summary_model.dart';
import 'package:abolashin/features/checkout/presentation/widgets/dotted_divider_painter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummery extends StatelessWidget {
  final List listItemName;
  final OrderSummryModel orderSummryModel;
  final String id;
  const OrderSummery({
    super.key,
    required this.orderSummryModel,
    required this.listItemName,
    required this.id,
  });

  void _goHome(BuildContext context) {
    BlocProvider.of<HomeCubit>(context).changeSelectIndexBottom(index: 0);
    context.replaceAllWith(const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.xxl,
            AppSpacing.page,
            AppSpacing.xxl,
          ),
          children: [
            _buildHeader(context),
            SizedBox(height: AppSpacing.xxl),
            AppCard(
              child: Column(
                children: [
                  _InfoRow(
                    label: 'invoice_number'.tr(),
                    value: id,
                    ltrValue: true,
                  ),
                  _InfoRow(
                    label: 'date'.tr(),
                    value: orderSummryModel.orderDate,
                    ltrValue: true,
                  ),
                  _InfoRow(
                    label: 'payment_method'.tr(),
                    value: 'cash_on_delivery'.tr(),
                  ),
                  _InfoRow(
                    label: 'total_quantity'.tr(),
                    value: '${orderSummryModel.orderItems.length}',
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            AppSectionTitle(title: 'order_items'.tr()),
            SizedBox(height: AppSpacing.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildItemsHeader(context),
                  for (final item in orderSummryModel.orderItems)
                    _buildItemRow(
                      context: context,
                      name: _nameFor(context, item.itemId),
                      quantity: item.quantity.toInt(),
                      price: item.price,
                    ),
                  SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                children: [
                  _InfoRow(
                    label: 'total'.tr(),
                    value: formatPriceWithCurrency(orderSummryModel.totalValue),
                  ),
                  _InfoRow(
                    label: 'discount'.tr(),
                    value: formatPriceWithCurrency(orderSummryModel.discount),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: CustomPaint(
                      painter: DottedDividerPainter(context: context),
                      child: SizedBox(height: 1.h, width: double.infinity),
                    ),
                  ),
                  _InfoRow(
                    label: 'final_price'.tr(),
                    value: formatPriceWithCurrency(orderSummryModel.finalValue),
                    emphasize: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
            DefaultButton(
              function: () => _goHome(context),
              text: 'home_page'.tr(),
              hasIcon: true,
              icon: const Icon(Icons.home_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  String _nameFor(BuildContext context, int itemId) {
    final product = listItemName.firstWhere(
      (element) => element.productId == itemId,
      orElse: () => cart.CartItem.empty(itemId.toInt()),
    );
    return context.locale.languageCode == 'ar'
        ? product.nameAr
        : product.nameEn;
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96.w,
          height: 96.h,
          decoration: BoxDecoration(
            color: context.colors.successSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: 60.r,
            color: context.colors.success,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          'order_success'.tr(),
          textAlign: TextAlign.center,
          style: GoogleFonts.alexandria(
            color: context.colors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.primarySoft,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('item_name'.tr(), style: _headerTextStyle(context)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'quantity'.tr(),
              textAlign: TextAlign.center,
              style: _headerTextStyle(context),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'unit_price'.tr(),
              textAlign: TextAlign.center,
              style: _headerTextStyle(context),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'total'.tr(),
              textAlign: TextAlign.end,
              style: _headerTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow({
    required BuildContext context,
    required String name,
    required int quantity,
    required double price,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _itemTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: _itemTextStyle(context),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatPrice(price),
              textAlign: TextAlign.center,
              style: _itemTextStyle(context),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatPrice(price * quantity),
              textAlign: TextAlign.end,
              style: _itemTextStyle(
                context,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerTextStyle(BuildContext context) => GoogleFonts.alexandria(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: context.colors.primary,
  );

  TextStyle _itemTextStyle(BuildContext context) => GoogleFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: context.colors.textPrimary,
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;
  final bool ltrValue;

  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    this.ltrValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.alexandria(
                fontSize: (emphasize ? 15 : 13).sp,
                fontWeight: emphasize ? FontWeight.w800 : FontWeight.w400,
                color:
                    emphasize
                        ? context.colors.textPrimary
                        : context.colors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              textDirection: ltrValue ? TextDirection.ltr : null,
              style: GoogleFonts.alexandria(
                fontSize: (emphasize ? 17 : 13).sp,
                fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
                color:
                    emphasize
                        ? context.colors.primary
                        : context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
