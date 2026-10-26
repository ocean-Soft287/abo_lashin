import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_radius.dart';
import '../themes/app_text_styles.dart';
import 'connection_status.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key, required this.status});

  final ConnectionStatus status;

  bool get _isConnected => status == ConnectionStatus.connected;

  String get _messageKey => switch (status) {
    ConnectionStatus.connected => 'back_online',
    ConnectionStatus.disconnected => 'no_internet_connection',
    ConnectionStatus.serverUnreachable => 'server_unreachable',
  };

  IconData get _icon => switch (status) {
    ConnectionStatus.connected => Icons.wifi_rounded,
    ConnectionStatus.disconnected => Icons.wifi_off_rounded,
    ConnectionStatus.serverUnreachable => Icons.cloud_off_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = _isConnected ? colors.success : colors.danger;
    final background = _isConnected ? colors.successSoft : colors.dangerSoft;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 250),
          tween: Tween(begin: 0.9, end: 1),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: color.withValues(alpha: .25)),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_icon, color: color),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      _messageKey.tr(),
                      style: AppTextStyles.font(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
