import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/addresses/data/model/all_address_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryAddressBar extends StatelessWidget {
  final AllAddressModel? address;
  final bool loading;

  /// The address list could not be loaded, so an empty one is not known to
  /// be empty.
  final bool failed;
  final VoidCallback onTap;

  const DeliveryAddressBar({
    super.key,
    required this.address,
    required this.loading,
    this.failed = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = address?.address?.trim() ?? '';
    final notes = address?.addressNotes?.trim() ?? '';
    final hasAddress = label.isNotEmpty;

    return Material(
      color: colors.surfaceMuted,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: loading ? null : onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 44.h),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppSpacing.md,
              end: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18.r,
                  color: colors.secondary,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child:
                      loading
                          ? Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.primary,
                              ),
                            ),
                          )
                          : Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${'deliver_to'.tr()}  ',
                                  style: TextStyle(color: colors.textSecondary),
                                ),
                                TextSpan(
                                  text:
                                      hasAddress
                                          ? [
                                            label,
                                            if (notes.isNotEmpty) notes,
                                          ].join(' · ')
                                          : (failed
                                                  ? 'addresses_load_failed'
                                                  : 'add_delivery_address')
                                              .tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        hasAddress
                                            ? colors.textPrimary
                                            : colors.primary,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.alexandria(fontSize: 12.sp),
                          ),
                ),
                TextButton(
                  onPressed: loading ? null : onTap,
                  style: TextButton.styleFrom(
                    minimumSize: Size(48.w, 36.h),
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    hasAddress ? 'change'.tr() : 'choose_address'.tr(),
                    style: GoogleFonts.alexandria(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
