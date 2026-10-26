import 'package:abolashin/features/addresses/data/model/all_address_model.dart';
import 'package:abolashin/features/checkout/presentation/widgets/order_summary.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/connectivity/connectivity_service.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/core/services/app_review_service.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart'
    as cart;
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_state.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_state.dart';
import 'package:abolashin/features/checkout/presentation/widgets/dotted_divider_painter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddOrderScreen extends StatefulWidget {
  final double total;
  final dynamic listItem;
  final AllAddressModel allAddressModel;
  final String address;
  final List<cart.CartItem> listItemName;
  const AddOrderScreen({
    required this.listItemName,
    super.key,
    required this.total,
    required this.listItem,
    required this.allAddressModel,
    required this.address,
  });

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  var keyForm = GlobalKey<FormState>();

  final notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CouponCubit>().revalidate();
  }

  @override
  void dispose() {
    notes.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(BuildContext context) async {
    if (!await context.ensureSignedIn()) return;
    if (!context.mounted) return;
    if (!ConnectivityService.instance.isOnline) {
      _toast(context, 'requires_connection'.tr());
      return;
    }
    final coupon = context.read<CouponCubit>().state;
    if (coupon.isLoading) return;
    BlocProvider.of<AddOrderCubit>(context).addOrder(
      discountCode: coupon.isApplied ? coupon.code : '',
      regionName: widget.allAddressModel.regionName,
      customerAddress: widget.address,
      customName: widget.allAddressModel.arabicName,
      districtName: widget.allAddressModel.districtName2,
      email: widget.allAddressModel.email,
      listItem: widget.listItem,
      total: widget.total,
      addition: num.parse(
        widget.allAddressModel.deliveryValue?.toString() ?? '0',
      ),
      discount: coupon.discountFor(widget.total),
      notes: notes.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final coupon = context.watch<CouponCubit>().state;
    final deliveryFee =
        double.tryParse(widget.allAddressModel.deliveryValue.toString()) ?? 0.0;
    final discount = coupon.discountFor(widget.total);
    final total = (widget.total - discount) + deliveryFee;

    return Scaffold(
      appBar: AppTopBar(title: 'complete_order'.tr()),
      body: Form(
        key: keyForm,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.xl,
            AppSpacing.page,
            AppSpacing.xxl,
          ),
          children: [
            AppSectionTitle(title: 'delivery_address'.tr()),
            SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconBadge(
                    icon: Icons.location_on_rounded,
                    color: context.colors.secondary,
                    background: context.colors.secondarySoft,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.address,
                          style: GoogleFonts.alexandria(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        if ((widget.allAddressModel.addressNotes ?? '')
                            .trim()
                            .isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            widget.allAddressModel.addressNotes!,
                            style: _secondary,
                          ),
                        ],
                        if (widget.allAddressModel.customerPhone
                            .trim()
                            .isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            widget.allAddressModel.customerPhone,
                            textDirection: TextDirection.ltr,
                            style: _secondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            AppSectionTitle(title: 'payment_method'.tr()),
            SizedBox(height: AppSpacing.sm),
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: context.colors.primary, width: 1.5),
              ),
              child: Row(
                children: [
                  _IconBadge(
                    icon: Icons.payments_outlined,
                    color: context.colors.primary,
                    background: context.colors.surface,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'cash_on_delivery'.tr(),
                      style: GoogleFonts.alexandria(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.radio_button_checked_rounded,
                    color: context.colors.primary,
                  ),
                ],
              ),
            ),
            if (widget.listItemName.isNotEmpty) ...[
              SizedBox(height: AppSpacing.xl),
              AppSectionTitle(
                title: 'order_items'.tr(),
                trailing: InfoChip(
                  label: '${widget.listItemName.length} ${'items_count'.tr()}',
                  background: context.colors.primarySoft,
                  foreground: context.colors.primary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < widget.listItemName.length; i++) ...[
                      if (i > 0) const Divider(),
                      _OrderItemRow(
                        item: widget.listItemName[i],
                        isArabic: isArabic,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            SizedBox(height: AppSpacing.xl),
            AppSectionTitle(title: 'notes'.tr()),
            SizedBox(height: AppSpacing.sm),
            TextField(
              controller: notes,
              minLines: 3,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              style: GoogleFonts.alexandria(
                fontSize: 14.sp,
                color: context.colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'please_enter_notes'.tr(),
                fillColor: context.colors.surface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: context.colors.border),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            AppSectionTitle(title: 'order_summary'.tr()),
            SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                children: [
                  _PriceRow(label: 'subtotal'.tr(), amount: widget.total),
                  SizedBox(height: AppSpacing.sm),
                  _PriceRow(label: 'delivery_fee'.tr(), amount: deliveryFee),
                  SizedBox(height: AppSpacing.sm),
                  _PriceRow(
                    label:
                        coupon.isApplied
                            ? '${'discount_value'.tr()} (${coupon.code})'
                            : 'discount_value'.tr(),
                    amount: discount > 0 ? -discount : 0,
                    color: context.colors.success,
                  ),
                  if (coupon.isLoading || coupon.errorKey != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    _CouponStatusLine(state: coupon),
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: CustomPaint(
                      painter: DottedDividerPainter(context: context),
                      child: SizedBox(height: 1.h, width: double.infinity),
                    ),
                  ),
                  _PriceRow(
                    label: 'total'.tr(),
                    amount: total,
                    emphasize: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _PlaceOrderBar(
        total: total,
        listItemName: widget.listItemName,
        enabled: !coupon.isLoading,
        onPlaceOrder: () => _placeOrder(context),
      ),
    );
  }

  TextStyle get _secondary => GoogleFonts.alexandria(
    fontSize: 12.sp,
    color: context.colors.textSecondary,
  );
}

void _toast(BuildContext context, String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.NONE,
    timeInSecForIosWeb: 1,
    backgroundColor: context.colors.danger,
    textColor: context.colors.onDanger,
    fontSize: 16.0.sp,
    webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
    webPosition: "center",
  );
}

class _PlaceOrderBar extends StatelessWidget {
  final double total;
  final List<cart.CartItem> listItemName;
  final bool enabled;
  final VoidCallback onPlaceOrder;

  const _PlaceOrderBar({
    required this.total,
    required this.listItemName,
    required this.enabled,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.md,
          ),
          child: BlocConsumer<AddOrderCubit, AddOrderState>(
            listener: (context, state) {
              if (state is AddOrderSuccess) {
                final summary = state.orderSummryModel;
                context.read<CartCubit>().clearCart();
                context.read<CouponCubit>().remove();
                if (summary != null) {
                  context.replaceAllWith(
                    OrderSummery(
                      orderSummryModel: summary,
                      listItemName: listItemName,
                      id: state.id,
                    ),
                  );
                } else {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
                Future<void>.delayed(
                  const Duration(seconds: 2),
                  AppReviewService.onOrderPlaced,
                );
                Fluttertoast.showToast(
                  msg: 'order_success'.tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: context.colors.primary,
                  textColor: context.colors.onPrimary,
                  fontSize: 16.0.sp,
                  webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
                  webPosition: "center",
                );
              }
              if (state is AddOrderError) {
                final failure = state.failure;
                _toast(
                  context,
                  failure != null && failure.type == FailureType.network
                      ? failure.messageKey.tr()
                      : 'order_error'.tr(),
                );
              }
            },
            builder: (context, state) {
              final loading = state is AddOrderLoading;
              return Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'total'.tr(),
                          style: GoogleFonts.alexandria(
                            fontSize: 12.sp,
                            color: context.colors.textSecondary,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            formatPriceWithCurrency(total),
                            style: GoogleFonts.alexandria(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w800,
                              color: context.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 6,
                    child: FilledButton(
                      onPressed: loading || !enabled ? null : onPlaceOrder,
                      child:
                          loading
                              ? SizedBox(
                                width: 22.w,
                                height: 22.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: context.colors.primary,
                                ),
                              )
                              : Text(
                                'complete_order'.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;

  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 42.h,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 22.r),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final cart.CartItem item;
  final bool isArabic;

  const _OrderItemRow({required this.item, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: context.colors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '${item.quantity}×',
              textDirection: TextDirection.ltr,
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: context.colors.primary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              isArabic ? item.nameAr : item.nameEn,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.alexandria(
                fontSize: 13.sp,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            formatPriceWithCurrency(item.priceAfterDiscount * item.quantity),
            style: GoogleFonts.alexandria(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool emphasize;
  final Color? color;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.emphasize = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Text(
          formatPriceWithCurrency(amount),
          style: GoogleFonts.alexandria(
            fontSize: (emphasize ? 17 : 13).sp,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            color:
                color ??
                (emphasize
                    ? context.colors.primary
                    : context.colors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _CouponStatusLine extends StatelessWidget {
  final CouponState state;

  const _CouponStatusLine({required this.state});

  @override
  Widget build(BuildContext context) {
    final error = state.errorKey;
    return Row(
      children: [
        if (state.isLoading)
          SizedBox(
            width: 12.w,
            height: 12.h,
            child: CircularProgressIndicator(
              strokeWidth: 1.6,
              color: context.colors.primary,
            ),
          )
        else
          Icon(
            Icons.error_outline_rounded,
            size: 14.r,
            color: context.colors.danger,
          ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            state.isLoading ? state.code : state.message ?? (error ?? '').tr(),
            style: GoogleFonts.alexandria(
              fontSize: 11.sp,
              color:
                  state.isLoading
                      ? context.colors.textSecondary
                      : context.colors.danger,
            ),
          ),
        ),
      ],
    );
  }
}
