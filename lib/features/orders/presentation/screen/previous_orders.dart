import 'package:abolashin/features/orders/presentation/widgets/empty_order_widget.dart';
import 'package:abolashin/features/orders/presentation/widgets/order_tracking_card.dart';
import 'package:abolashin/features/orders/presentation/widgets/previous_order_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/route/routing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/orders/presentation/manager/previous_order_cubit.dart';
import 'package:abolashin/features/orders/presentation/manager/previous_order_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviousOrders extends StatefulWidget {
  const PreviousOrders({super.key});

  @override
  State<PreviousOrders> createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  @override
  Widget build(BuildContext context) {
    if (!context.isSignedIn) {
      return Scaffold(
        appBar: AppTopBar(title: 'my_orders'.tr()),
        body: AppStateView(
          icon: Icons.lock_outline_rounded,
          title: 'login_required_title'.tr(),
          message: 'login_required_message'.tr(),
          actionLabel: 'login_now'.tr(),
          actionIcon: Icons.login_rounded,
          onAction: () async {
            await Navigator.of(context).pushNamed(AppRoute.login);
            if (mounted) setState(() {});
          },
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      animationDuration: const Duration(milliseconds: 300),
      child: Scaffold(
        appBar: AppTopBar(title: 'my_orders'.tr()),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.md,
                AppSpacing.page,
                AppSpacing.sm,
              ),
              child: Container(
                height: 46.h,
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: context.colors.border),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: context.colors.brand,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  labelColor: context.colors.onBrand,
                  unselectedLabelColor: context.colors.textSecondary,
                  labelStyle: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.alexandria(fontSize: 13.sp),
                  tabs: [
                    Tab(text: 'current_orders'.tr()),
                    Tab(text: 'previous_orders'.tr()),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [_TrackingOrdersTab(), _PreviousOrdersTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingOrdersTab extends StatefulWidget {
  const _TrackingOrdersTab();

  @override
  State<_TrackingOrdersTab> createState() => _TrackingOrdersTabState();
}

class _TrackingOrdersTabState extends State<_TrackingOrdersTab> {
  late final PreviousOrderCubit _cubit =
      PreviousOrderCubit()..startOrderTrackingRealtime();

  bool _loaded = false;

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<PreviousOrderCubit, PreviousOrderState>(
        listenWhen:
            (_, state) =>
                state is OrderTrackingSuccess || state is OrderTrackingError,
        listener: (context, state) {
          if (!_loaded) setState(() => _loaded = true);
        },
        buildWhen:
            (_, state) =>
                state is OrderTrackingSuccess || state is OrderTrackingError,
        builder: (context, state) {
          final orders = _cubit.orderTrackingDetails;
          if (orders.isNotEmpty) {
            return OrderTrackingCard(orderTrackingCubit: _cubit);
          }
          if (!_loaded) return const AppLoader();
          if (state is OrderTrackingError) {
            return ConnectivityRefresh(
              onReconnect: _cubit.getOrderTrackingDetails,
              child: AppStateView.failure(
                failure: state.failure,
                onRetry: _cubit.getOrderTrackingDetails,
              ),
            );
          }
          return EmptyOrdersWidget(
            actionText: 'browse_and_order'.tr(),
            message: 'no_tracking_orders'.tr(),
          );
        },
      ),
    );
  }
}

class _PreviousOrdersTab extends StatefulWidget {
  const _PreviousOrdersTab();

  @override
  State<_PreviousOrdersTab> createState() => _PreviousOrdersTabState();
}

class _PreviousOrdersTabState extends State<_PreviousOrdersTab> {
  final PreviousOrderCubit _cubit = PreviousOrderCubit();

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _cubit.getPreviousOrders();
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<PreviousOrderCubit, PreviousOrderState>(
        builder: (context, state) {
          final orders = _cubit.previousOrderList;
          if (orders.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: _cubit.getPreviousOrders,
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.sm,
                  AppSpacing.page,
                  AppSpacing.xxl,
                ),
                separatorBuilder:
                    (context, index) => SizedBox(height: AppSpacing.md),
                itemCount: orders.length,
                itemBuilder:
                    (context, index) =>
                        PreviousOrderItem(previousOrder: orders[index]),
              ),
            );
          }
          if (!_loaded) return const AppLoader();
          if (state is GetPreviousOrderError) {
            void retry() {
              setState(() => _loaded = false);
              _load();
            }

            return ConnectivityRefresh(
              onReconnect: retry,
              child: AppStateView.failure(
                failure: state.failure,
                onRetry: retry,
              ),
            );
          }
          return EmptyOrdersWidget(
            actionText: 'shop_now'.tr(),
            message: 'no_previous_orders'.tr(),
          );
        },
      ),
    );
  }
}
