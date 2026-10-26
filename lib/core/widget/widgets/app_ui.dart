import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/themes/app_text_styles.dart';
import 'package:abolashin/core/themes/app_theme.dart';
import 'package:abolashin/core/connectivity/connectivity_service.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final NumberFormat _priceFormat = NumberFormat('#,##0.00', 'en');

String formatPrice(num? value) => _priceFormat.format(value ?? 0);

String formatPriceWithCurrency(num? value) =>
    '${formatPrice(value)}${'currency'.tr()}';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;

  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canPop = showBack && Navigator.of(context).canPop();
    return AnnotatedRegion(
      value: AppTheme.overlayStyle(colors, Theme.of(context).brightness),
      child: Material(
        color: colors.primarySoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppRadius.xl),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: preferredSize.height,
            child: NavigationToolbar(
              leading:
                  leading ??
                  (canPop
                      ? IconButton(
                        tooltip:
                            MaterialLocalizations.of(context).backButtonTooltip,
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: colors.textPrimary,
                        ),
                        onPressed: onBack ?? () => Navigator.maybePop(context),
                      )
                      : null),
              middle: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              trailing:
                  actions == null
                      ? null
                      : Row(mainAxisSize: MainAxisSize.min, children: actions!),
              middleSpacing: 8.w,
            ),
          ),
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final double? radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? AppRadius.lg),
      side: BorderSide(color: colors.cardBorder),
    );
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: color ?? colors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? background;
  final Color? foreground;

  const InfoChip({
    super.key,
    required this.label,
    this.icon,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textColor = foreground ?? colors.textSecondary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: background ?? colors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13.r, color: textColor),
            SizedBox(width: 4.w),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData actionIcon;
  final bool isError;

  const AppStateView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.actionIcon = Icons.refresh_rounded,
    this.isError = false,
  });

  factory AppStateView.empty({
    Key? key,
    String? title,
    String? message,
    IconData icon = Icons.inventory_2_outlined,
  }) => AppStateView(
    key: key,
    icon: icon,
    title: title ?? 'no_results_found'.tr(),
    message: message,
  );

  factory AppStateView.error({
    Key? key,
    VoidCallback? onRetry,
    String? message,
  }) => AppStateView(
    key: key,
    icon: Icons.wifi_off_rounded,
    title: 'something_went_wrong'.tr(),
    message: message ?? 'check_connection'.tr(),
    actionLabel: onRetry == null ? null : 'retry'.tr(),
    onAction: onRetry,
    isError: true,
  );

  factory AppStateView.failure({
    Key? key,
    Failure? failure,
    VoidCallback? onRetry,
  }) {
    final offline =
        failure?.type == FailureType.network &&
        !ConnectivityService.instance.isOnline;
    if (offline) {
      return AppStateView(
        key: key,
        icon: Icons.wifi_off_rounded,
        title: 'offline_title'.tr(),
        message: 'offline_message'.tr(),
        actionLabel: onRetry == null ? null : 'retry'.tr(),
        onAction: onRetry,
        isError: true,
      );
    }
    return AppStateView(
      key: key,
      icon:
          failure?.type == FailureType.network
              ? Icons.wifi_off_rounded
              : Icons.error_outline_rounded,
      title: 'something_went_wrong'.tr(),
      message: (failure?.messageKey ?? 'error_unknown').tr(),
      actionLabel: onRetry == null ? null : 'retry'.tr(),
      onAction: onRetry,
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconColor = isError ? colors.danger : colors.textHint;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.h,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40.r, color: iconColor),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.font(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            if (message != null) ...[
              SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.font(
                  fontSize: 13.sp,
                  height: 1.5,
                  color: colors.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.xl),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: Icon(actionIcon),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 32.w,
        height: 32.h,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: context.colors.primary,
        ),
      ),
    );
  }
}

class AppMenuTile extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;

  const AppMenuTile({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = color ?? colors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 56.h),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: leading ?? Icon(icon, size: 21.r, color: tint),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.font(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: color ?? colors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  Icon(Icons.chevron_right_rounded, color: colors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

class AppSectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const AppSectionTitle({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.font(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
