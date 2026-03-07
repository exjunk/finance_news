// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // System UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0F),
    ),
  );

  // Initialize timezone data (synchronous — no risk of throwing)
  tz.initializeTimeZones();

  // Start the app immediately so the reviewer/user sees the UI right away
  runApp(
    const ProviderScope(
      child: StockSwipeApp(),
    ),
  );

  // Initialise notifications in the background AFTER the app is visible.
  // Wrapped in try/catch so a notification failure never crashes the app.
  unawaited(_initNotifications());
}

Future<void> _initNotifications() async {
  try {
    final notifService = NotificationService();
    await notifService.initialize();
    await notifService.requestPermission();
    await notifService.scheduleMarketOpenNotification();
    await notifService.scheduleMarketCloseNotification();
  } catch (_) {
    // Non-fatal — the app continues to work without scheduled notifications.
  }
}
