import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import '../helpers/logger.dart';
import 'local_notifications.dart';
import 'notification_payload.dart';
import 'notification_router.dart';

/// Entry point for pushes received while the app is in the background or
/// terminated. Runs in its own isolate, so Firebase is initialised here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Messages with a `notification` block are already shown by the OS;
    // showing another would duplicate them.
    if (message.notification != null) return;
    await LocalNotifications.initialize();
    await MessagingConfig.showDataMessage(message);
  } catch (error, stackTrace) {
    loggerError('Background message failed: $error', stackTrace: stackTrace);
  }
}

/// Firebase Cloud Messaging lifecycle: listeners, foreground display,
/// taps from every app state and the permission request.
abstract interface class MessagingConfig {
  static bool _initializationComplete = false;
  static bool _listenersRegistered = false;
  static bool _permissionRequested = false;
  static final List<StreamSubscription<RemoteMessage>> _subscriptions = [];

  /// Call once after `Firebase.initializeApp`; repeated calls do nothing.
  /// Failures are logged and leave the rest of the app working.
  static Future<void> initFirebaseMessaging() async {
    try {
      if (!_initializationComplete) {
        await LocalNotifications.initialize(onTap: _onLocalNotificationTap);
        // iOS then shows `notification` messages itself in the foreground,
        // so they need no local copy.
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
              alert: true,
              badge: true,
              sound: true,
            );
        _initializationComplete = true;
      }
      if (!_listenersRegistered) {
        _subscriptions
          ..add(FirebaseMessaging.onMessage.listen(_onForegroundMessage))
          ..add(FirebaseMessaging.onMessageOpenedApp.listen(_onMessageTap));
        _listenersRegistered = true;
      }
      await _handleLaunchNotification();
    } catch (error, stackTrace) {
      loggerError('Notification setup failed: $error', stackTrace: stackTrace);
    }
  }

  /// Call when the home shell is first shown: replays a held notification
  /// tap and asks for permission once, outside the splash screen.
  static Future<void> onAppReady() async {
    NotificationRouter.markReady();
    await requestPermissionIfNeeded();
  }

  /// Asks only while the user has not decided yet, so a refusal is never
  /// followed by another prompt.
  static Future<void> requestPermissionIfNeeded() async {
    if (_permissionRequested) return;
    _permissionRequested = true;
    try {
      final messaging = FirebaseMessaging.instance;
      var settings = await messaging.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        settings = await messaging.requestPermission();
      }
      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
        case AuthorizationStatus.provisional:
          logger('Notifications allowed');
        case AuthorizationStatus.denied:
        case AuthorizationStatus.notDetermined:
          // The app keeps working; the user can enable them in settings.
          loggerWarn('Notifications not allowed');
      }
    } catch (error, stackTrace) {
      loggerError(
        'Notification permission request failed: $error',
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> _handleLaunchNotification() async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _onMessageTap(initial);
    final launch = await LocalNotifications.launchResponse();
    if (launch != null) _onLocalNotificationTap(launch);
  }

  static void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      // Shown by iOS itself (presentation options above).
      if (defaultTargetPlatform == TargetPlatform.iOS) return;
      // Android shows nothing while the app is open, so show it locally.
      unawaited(
        LocalNotifications.show(
          id: _notificationId(message),
          title: notification.title,
          body: notification.body,
          payload: _payloadOf(message),
        ),
      );
      return;
    }
    unawaited(showDataMessage(message));
  }

  /// Shows a data-only message that carries `title`/`body`; data without
  /// them is silent by design and is not shown.
  static Future<void> showDataMessage(RemoteMessage message) async {
    final title = message.data['title']?.toString();
    final body = message.data['body']?.toString();
    if ((title ?? '').isEmpty && (body ?? '').isEmpty) return;
    await LocalNotifications.show(
      id: _notificationId(message),
      title: title,
      body: body,
      payload: _payloadOf(message),
    );
  }

  static void _onMessageTap(RemoteMessage message) {
    NotificationRouter.open(
      NotificationPayload.fromData(message.data, messageId: message.messageId),
    );
  }

  static void _onLocalNotificationTap(NotificationResponse response) {
    final payload = NotificationPayload.fromJson(response.payload);
    if (payload != null) NotificationRouter.open(payload);
  }

  /// Message data plus its id, so a tap on the local copy is recognised as
  /// the same notification.
  static String _payloadOf(RemoteMessage message) => jsonEncode({
    ...message.data,
    if (message.messageId != null)
      NotificationPayload.messageIdKey: message.messageId,
  });

  /// Same message, same id: a re-delivery replaces instead of stacking.
  static int _notificationId(RemoteMessage message) {
    final key =
        message.messageId ??
        '${message.notification?.title}${message.notification?.body}'
            '${message.data}';
    return key.hashCode & 0x7fffffff;
  }

  /// Stops listening; shown and scheduled notifications are left alone.
  static Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    _listenersRegistered = false;
  }
}
