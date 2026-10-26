import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../helpers/logger.dart';

/// Thin wrapper over [FlutterLocalNotificationsPlugin]: channels, showing,
/// scheduling and cancelling. Push handling lives in `MessagingConfig`.
abstract final class LocalNotifications {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  /// Kept from the original setup; also FCM's default channel (see
  /// AndroidManifest.xml) so pushes and local copies share one setting.
  static const AndroidNotificationChannel generalChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Orders, offers and other updates from Abu Lashin.',
        importance: Importance.max,
      );

  /// Separate so users can turn reminders off without losing order updates.
  static const AndroidNotificationChannel reminderChannel =
      AndroidNotificationChannel(
        'cart_reminders',
        'Cart reminders',
        description: 'A reminder when items are left in the cart.',
      );

  /// The only icon the project ships. A monochrome `ic_notification`
  /// drawable would render better on Android 5+.
  static const String androidIcon = '@mipmap/launcher_icon';

  static bool _initialized = false;

  /// Safe to call more than once and from the background isolate.
  static Future<void> initialize({
    DidReceiveNotificationResponseCallback? onTap,
  }) async {
    if (_initialized) return;
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(androidIcon),
        // Permission is requested once, after the home screen shows.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: onTap,
    );
    final android =
        plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await android?.createNotificationChannel(generalChannel);
    await android?.createNotificationChannel(reminderChannel);
    _initialized = true;
  }

  /// The tap that launched the app from a terminated state, if any.
  static Future<NotificationResponse?> launchResponse() async {
    final details = await plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    return details?.notificationResponse;
  }

  static NotificationDetails _details(AndroidNotificationChannel channel) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority:
            channel.importance == Importance.max
                ? Priority.high
                : Priority.defaultPriority,
        icon: androidIcon,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static Future<void> show({
    required int id,
    String? title,
    String? body,
    String? payload,
    AndroidNotificationChannel channel = generalChannel,
  }) async {
    try {
      await plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _details(channel),
        payload: payload,
      );
    } catch (error, stackTrace) {
      loggerError(
        'Could not show notification $id: $error',
        stackTrace: stackTrace,
      );
    }
  }

  /// Replaces any pending notification with the same [id]. Delivery is
  /// inexact: Android may defer it in Doze, and nothing fires if the user
  /// has denied notifications.
  static Future<void> schedule({
    required int id,
    required Duration after,
    String? title,
    String? body,
    String? payload,
    AndroidNotificationChannel channel = reminderChannel,
  }) async {
    try {
      await plugin.zonedSchedule(
        id: id,
        // An absolute instant, so the device time zone does not matter.
        scheduledDate: tz.TZDateTime.now(tz.UTC).add(after),
        notificationDetails: _details(channel),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
        payload: payload,
      );
    } catch (error, stackTrace) {
      loggerError(
        'Could not schedule notification $id: $error',
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> cancel(int id) async {
    try {
      await plugin.cancel(id: id);
    } catch (error, stackTrace) {
      loggerError(
        'Could not cancel notification $id: $error',
        stackTrace: stackTrace,
      );
    }
  }

  /// Cancels scheduled notifications only; ones already shown stay.
  static Future<void> cancelScheduled() async {
    try {
      await plugin.cancelAllPendingNotifications();
    } catch (error, stackTrace) {
      loggerError(
        'Could not cancel scheduled notifications: $error',
        stackTrace: stackTrace,
      );
    }
  }
}
