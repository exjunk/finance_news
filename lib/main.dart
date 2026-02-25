// lib/main.dart
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

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize notifications
  final notifService = NotificationService();
  await notifService.initialize();
  await notifService.requestPermission();
  await notifService.scheduleMarketOpenNotification();
  await notifService.scheduleMarketCloseNotification();

  runApp(
    const ProviderScope(
      child: StockSwipeApp(),
    ),
  );
}
