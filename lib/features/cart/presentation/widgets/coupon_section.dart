import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CouponSection extends StatefulWidget {
  final double subtotal;

  const CouponSection({super.key, required this.subtotal});

  @override
  State<CouponSection> createState() => _CouponSectionState();
}

class _CouponSectionState extends State<CouponSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;
    FocusScope.of(context).unfocus();
    if (!await context.ensureSignedIn()) return;
    if (!mounted) return;
    await context.read<CouponCubit>().apply(code);
  }

  void _remove() {
    _controller.clear();
    context.read<CouponCubit>().remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        if (state.isApplied) {
          return _AppliedCoupon(
            code: state.code,
            discount: state.discountFor(widget.subtotal),
            onRemove: _remove,
          );
        }
        final error = state.errorKey;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CouponInput(
              controller: _controller,
              loading: state.isLoading,
              hasError: error != null,
              onApply: _apply,
            ),
            if (error != null)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: AppSpacing.xs,
                  start: AppSpacing.xs,
                ),
                child: Text(
                  state.message ?? error.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 11.sp,
                    color: context.colors.danger,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CouponInput extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final bool hasError;
  final VoidCallback onApply;

  const _CouponInput({
    required this.controller,
    required this.loading,
    required this.hasError,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: hasError ? colors.danger : Colors.transparent,
      ),
    );
    return SizedBox(
      height: 44.h,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !loading,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              onSubmitted: (_) => onApply(),
              style: GoogleFonts.alexandria(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'enter_discount_code'.tr(),
                prefixIcon: Icon(
                  Icons.local_offer_outlined,
                  size: 18.r,
                  color: colors.secondary,
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 40.w),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                enabledBorder: border,
                disabledBorder: border,
                border: border,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          SizedBox(
            height: 44.h,
            child: FilledButton.tonal(
              onPressed: loading ? null : onApply,
              style: FilledButton.styleFrom(
                minimumSize: Size(76.w, 44.h),
                backgroundColor: colors.primarySoft,
                foregroundColor: colors.primary,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              ),
              child:
                  loading
                      ? SizedBox(
                        width: 18.w,
                        height: 18.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.primary,
                        ),
                      )
                      : Text('apply'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppliedCoupon extends StatelessWidget {
  final String code;
  final double discount;
  final VoidCallback onRemove;

  const _AppliedCoupon({
    required this.code,
    required this.discount,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 44.h,
      padding: EdgeInsetsDirectional.only(start: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.successSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 18.r, color: colors.success),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'coupon_applied'.tr(args: [code]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ),
          Text(
            '-${formatPriceWithCurrency(discount)}',
            style: GoogleFonts.alexandria(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: colors.success,
            ),
          ),
          IconButton(
            tooltip: 'remove_coupon'.tr(),
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.close_rounded,
              size: 18.r,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
