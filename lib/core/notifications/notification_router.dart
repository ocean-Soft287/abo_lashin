import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/favorites/presentation/screen/favorite_screen.dart';
import '../../features/home/presentation/manager/home_cubit.dart';
import '../../features/orders/presentation/screen/previous_orders.dart';
import '../../features/products/presentation/screen/product_details_screen.dart';
import '../auth/auth_guard.dart';
import '../connectivity/app_navigator.dart';
import '../helpers/logger.dart';
import 'notification_payload.dart';

/// Opens the screen a tapped notification points to.
///
/// Taps that arrive before the home shell is on screen (cold start, splash,
/// login) are held and replayed by [markReady]; navigating earlier would be
/// wiped by the splash screen's `replaceAll`.
abstract final class NotificationRouter {
  static bool _ready = false;
  static NotificationPayload? _pending;
  static final Set<String> _handledMessageIds = {};

  static const int _homeTab = 0;
  static const int _cartTab = 2;

  /// Called once the home shell has rendered.
  static void markReady() {
    if (_ready) return;
    _ready = true;
    final pending = _pending;
    _pending = null;
    if (pending != null) _navigateAfterFrame(pending);
  }

  static void open(NotificationPayload payload) {
    final id = payload.messageId;
    // FCM and the local plugin can both report the same launch tap.
    if (id != null && !_handledMessageIds.add(id)) return;
    if (payload.destination == NotificationDestination.none) {
      logger('Notification has no destination (type: ${payload.type})');
      return;
    }
    if (!_ready || AppNavigator.navigatorKey.currentState == null) {
      // Only the latest tap matters; replaying several would stack screens.
      _pending = payload;
      return;
    }
    _navigateAfterFrame(payload);
  }

  static void _navigateAfterFrame(NotificationPayload payload) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate(payload));
  }

  static Future<void> _navigate(NotificationPayload payload) async {
    final navigator = AppNavigator.navigatorKey.currentState;
    final context = AppNavigator.navigatorKey.currentContext;
    if (navigator == null || context == null) {
      _pending = payload;
      return;
    }
    try {
      switch (payload.destination) {
        case NotificationDestination.product:
          navigator.push(
            MaterialPageRoute(
              builder:
                  (_) => ProductDetailsScreen(
                    productId: payload.productId,
                    categoryId: payload.categoryId,
                  ),
            ),
          );
        case NotificationDestination.orders:
          // Orders belong to an account; guests get the usual sign-in prompt.
          if (!await context.ensureSignedIn()) return;
          navigator.push(
            MaterialPageRoute(builder: (_) => const PreviousOrders()),
          );
        case NotificationDestination.favorites:
          navigator.push(
            MaterialPageRoute(builder: (_) => const FavoriteScreen()),
          );
        case NotificationDestination.cart:
          _showHomeTab(navigator, context, _cartTab);
        case NotificationDestination.home:
          _showHomeTab(navigator, context, _homeTab);
        case NotificationDestination.none:
          break;
      }
    } catch (error, stackTrace) {
      loggerError(
        'Could not open notification destination '
        '${payload.destination}: $error',
        stackTrace: stackTrace,
      );
    }
  }

  static void _showHomeTab(
    NavigatorState navigator,
    BuildContext context,
    int tab,
  ) {
    final home = context.read<HomeCubit>();
    navigator.popUntil((route) => route.isFirst);
    home.changeSelectIndexBottom(index: tab);
  }
}
