import 'dart:convert';

import '../helpers/logger.dart';

/// Screens a notification can open. Only screens that exist in the app and
/// can be built from the payload alone are listed.
enum NotificationDestination { product, orders, favorites, cart, home, none }

/// Data contract for push and local notifications.
///
/// Expected keys (all optional, all strings in FCM `data`):
/// * `type`: `order_confirmed`, `order_preparing`, `order_shipped`,
///   `order_delivered`, `order_cancelled`, `new_product`, `promotion`,
///   `price_drop`, `back_in_stock`, `cart_reminder`.
/// * `route`: legacy alternative to `type`: `product`, `orders`, `offers`,
///   `favorites`, `cart`, `home`.
/// * `productId`, `categoryId`, `orderId`.
/// * `title`, `body`: used only for data-only messages.
class NotificationPayload {
  final String? type;
  final String? route;
  final int? productId;
  final String? categoryId;
  final int? orderId;

  /// FCM message id, used to ignore the same tap arriving twice.
  final String? messageId;

  const NotificationPayload({
    this.type,
    this.route,
    this.productId,
    this.categoryId,
    this.orderId,
    this.messageId,
  });

  static const Set<String> orderTypes = {
    'order_confirmed',
    'order_preparing',
    'order_shipped',
    'order_delivered',
    'order_cancelled',
  };

  static const String messageIdKey = 'messageId';

  factory NotificationPayload.fromData(
    Map<String, dynamic> data, {
    String? messageId,
  }) {
    return NotificationPayload(
      type: _text(data['type'])?.toLowerCase(),
      route: _text(data['route'])?.toLowerCase(),
      productId: _positiveInt(data['productId']),
      categoryId: _text(data['categoryId']),
      orderId: _positiveInt(data['orderId']),
      messageId: messageId ?? _text(data[messageIdKey]),
    );
  }

  /// Parses a local notification payload; null when it is missing or not a
  /// JSON object.
  static NotificationPayload? fromJson(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) {
        loggerWarn('Ignoring notification payload that is not an object');
        return null;
      }
      return NotificationPayload.fromData(Map<String, dynamic>.from(decoded));
    } on FormatException catch (error) {
      loggerWarn('Ignoring malformed notification payload: $error');
      return null;
    }
  }

  NotificationDestination get destination {
    if (orderTypes.contains(type) || route == 'orders' || route == 'order') {
      return NotificationDestination.orders;
    }
    const productTypes = {
      'new_product',
      'promotion',
      'price_drop',
      'back_in_stock',
    };
    // Never open a product without a valid id.
    if (productId != null &&
        (productTypes.contains(type) || route == 'product')) {
      return NotificationDestination.product;
    }
    if (type == 'price_drop' ||
        type == 'back_in_stock' ||
        route == 'favorites') {
      return NotificationDestination.favorites;
    }
    if (type == 'cart_reminder' || route == 'cart') {
      return NotificationDestination.cart;
    }
    if (type == 'promotion' ||
        type == 'new_product' ||
        route == 'offers' ||
        route == 'home') {
      return NotificationDestination.home;
    }
    return NotificationDestination.none;
  }

  static String? _text(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }

  static int? _positiveInt(dynamic value) {
    final number = int.tryParse(_text(value) ?? '');
    return number != null && number > 0 ? number : null;
  }
}
