import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/cart/data/model/cart_item_model.dart';
import '../../features/cart/presentation/manager/cart_cubit.dart';
import '../../features/cart/presentation/manager/cart_state.dart';
import '../helpers/logger.dart';
import 'local_notifications.dart';

/// One local reminder for items left in the cart.
///
/// The cart lives only on this device, so this cannot see an order placed
/// from another device or the website; it relies on the cart being emptied
/// here (checkout success and sign-out both clear it).
abstract final class CartReminder {
  /// Stable so a new schedule replaces the old one.
  static const int notificationId = 41001;
  static const Duration delay = Duration(hours: 24);
  static const String _signatureKey = 'cart_reminder_signature';

  static StreamSubscription<CartState>? _subscription;

  static void attach(CartCubit cart, SharedPreferences preferences) {
    if (_subscription != null) return;
    _subscription = cart.stream.listen((state) {
      if (state is CartLoading) return;
      unawaited(_sync(cart.cartItems, preferences));
    });
  }

  static Future<void> _sync(
    List<CartItem> items,
    SharedPreferences preferences,
  ) async {
    try {
      final previous = preferences.getString(_signatureKey);
      if (items.isEmpty) {
        if (previous == null) return;
        await preferences.remove(_signatureKey);
        await LocalNotifications.cancel(notificationId);
        return;
      }
      // Reloading the same cart at startup must not re-arm the reminder.
      final signature = _signature(items);
      if (signature == previous) return;
      await preferences.setString(_signatureKey, signature);
      final count = items.fold<int>(0, (sum, item) => sum + item.quantity);
      await LocalNotifications.schedule(
        id: notificationId,
        after: delay,
        title: 'cart_reminder_title'.tr(),
        body: 'cart_reminder_body'.tr(args: ['$count']),
        payload: jsonEncode({'type': 'cart_reminder'}),
      );
    } catch (error, stackTrace) {
      loggerError(
        'Cart reminder update failed: $error',
        stackTrace: stackTrace,
      );
    }
  }

  static String _signature(List<CartItem> items) {
    final lines = [for (final item in items) '${item.barcode}x${item.quantity}']
      ..sort();
    return lines.join(',');
  }
}
