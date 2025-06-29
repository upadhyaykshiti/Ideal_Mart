

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'screens/onboarding_screen.dart';
import 'screens/registration_screen.dart';
import 'services/api_service.dart';
import 'dart:async';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone for scheduling notifications
  tz.initializeTimeZones();

  // Local notification settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Get onboarding state
  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  // Schedule notifications on app launch
  await scheduleAllReminders();

  runApp(MyApp(onboardingComplete: onboardingComplete));
}

Future<void> scheduleAllReminders() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) return;

    final shoppingItems = await ApiService.fetchShoppingItems(userId);
    for (final item in shoppingItems) {
      if (item['reminder_enabled'] == true) {
        final reminderTimeStr = item['reminder_time'];
        final timeParts = reminderTimeStr.split(":");
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        final now = DateTime.now();
        DateTime scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
        if (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(Duration(days: 1)); // Tomorrow
        }

        await flutterLocalNotificationsPlugin.zonedSchedule(
          item['_id'].hashCode,
          item['title'],
          'Time to restock!',
          tz.TZDateTime.from(scheduledTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'Reminder channel',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
  } catch (e) {
    debugPrint("Error scheduling reminders: $e");
  }
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;
  const MyApp({required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ideal Mart',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: onboardingComplete ? RegistrationScreen() : OnboardingScreen(),
    );
  }
}

