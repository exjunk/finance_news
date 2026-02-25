// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings =
        InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
  }

  Future<bool> requestPermission() async {
    final android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  Future<void> scheduleMarketOpenNotification() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(AppConstants.prefNotifMarketOpen) ?? true)) return;

    await _plugin.cancel(AppConstants.marketOpenNotificationId);

    final ist = tz.getLocation('Asia/Kolkata');
    final now = tz.TZDateTime.now(ist);
    var scheduled = tz.TZDateTime(
      ist,
      now.year,
      now.month,
      now.day,
      AppConstants.marketOpenHourIST,
      AppConstants.marketOpenMinuteIST,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    try {
      await _plugin.zonedSchedule(
        AppConstants.marketOpenNotificationId,
        'Market is Open 🔔',
        'Swipe today\'s top stories',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'market_open',
            'Market Open',
            channelDescription: 'Daily market opening reminder',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // Fall back to inexact if exact alarm permission not granted
      await _plugin.zonedSchedule(
        AppConstants.marketOpenNotificationId,
        'Market is Open 🔔',
        'Swipe today\'s top stories',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'market_open',
            'Market Open',
            channelDescription: 'Daily market opening reminder',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleMarketCloseNotification() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(AppConstants.prefNotifMarketClose) ?? true)) return;

    await _plugin.cancel(AppConstants.marketCloseNotificationId);

    final ist = tz.getLocation('Asia/Kolkata');
    final now = tz.TZDateTime.now(ist);
    var scheduled = tz.TZDateTime(
      ist,
      now.year,
      now.month,
      now.day,
      AppConstants.marketCloseHourIST,
      AppConstants.marketCloseMinuteIST,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    try {
      await _plugin.zonedSchedule(
        AppConstants.marketCloseNotificationId,
        'Market Closed 📊',
        'See how Nifty did today',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'market_close',
            'Market Close',
            channelDescription: 'Daily market closing digest',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      await _plugin.zonedSchedule(
        AppConstants.marketCloseNotificationId,
        'Market Closed 📊',
        'See how Nifty did today',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'market_close',
            'Market Close',
            channelDescription: 'Daily market closing digest',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
