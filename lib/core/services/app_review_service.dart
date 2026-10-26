import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abolashin/core/services/external_links.dart';

abstract class AppReviewPolicy {
  static const int minSuccessfulOrders = 2;

  static const Duration cooldown = Duration(days: 120);

  static bool shouldRequest({
    required int successfulOrders,
    required DateTime? lastRequestedAt,
    required DateTime now,
  }) {
    if (successfulOrders < minSuccessfulOrders) return false;
    if (lastRequestedAt == null) return true;
    return now.difference(lastRequestedAt) >= cooldown;
  }
}

abstract class AppReviewService {
  static const String _ordersKey = 'review_successful_orders';
  static const String _lastRequestKey = 'review_last_requested_at';

  @visibleForTesting
  static InAppReview Function() reviewer = () => InAppReview.instance;

  static Future<void> onOrderPlaced({DateTime? now}) async {
    try {
      final orders = (_readInt(_ordersKey) ?? 0) + 1;
      await _preferences.setInt(_ordersKey, orders);

      final current = now ?? DateTime.now();
      final last = _readInt(_lastRequestKey);
      final due = AppReviewPolicy.shouldRequest(
        successfulOrders: orders,
        lastRequestedAt:
            last == null ? null : DateTime.fromMillisecondsSinceEpoch(last),
        now: current,
      );
      if (!due) return;

      final review = reviewer();
      if (!await review.isAvailable()) return;
      await _preferences.setInt(
        _lastRequestKey,
        current.millisecondsSinceEpoch,
      );
      await review.requestReview();
    } catch (_) {}
  }

  static Future<bool> openStoreListing() async {
    try {
      await reviewer().openStoreListing();
      return true;
    } catch (_) {
      return ExternalLinks.openStoreListing();
    }
  }

  static SharedPreferences get _preferences => getIt<SharedPreferences>();

  static int? _readInt(String key) {
    final value = _preferences.get(key);
    return value is int ? value : null;
  }
}
