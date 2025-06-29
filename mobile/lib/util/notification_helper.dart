

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationHelper {
//   static final FlutterLocalNotificationsPlugin _plugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> scheduleRepeatingNotification({
//     required String title,
//     required DateTime scheduledTime,
//     required String repeatInterval,
//   }) async {
//     DateTimeComponents? matchComponents;

//     if (repeatInterval == 'daily') {
//       matchComponents = DateTimeComponents.time;
//     } else if (repeatInterval == 'weekly') {
//       matchComponents = DateTimeComponents.dayOfWeekAndTime;
//     } else if (repeatInterval == 'monthly') {
//       matchComponents = DateTimeComponents.dayOfMonthAndTime;
//     }

//     await _plugin.zonedSchedule(
//       title.hashCode, // unique ID
//       title,
//       'Time to restock!',
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channel_id',
//           'channel_name',
//           channelDescription: 'Reminder notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: matchComponents,
//     );
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ✅ Schedule repeating notifications
  static Future<void> scheduleRepeatingNotification({
    required String title,
    required DateTime scheduledTime,
    required String repeatInterval,
  }) async {
    DateTimeComponents? matchComponents;

    if (repeatInterval == 'daily') {
      matchComponents = DateTimeComponents.time;
    } else if (repeatInterval == 'weekly') {
      matchComponents = DateTimeComponents.dayOfWeekAndTime;
    } else if (repeatInterval == 'monthly') {
      matchComponents = DateTimeComponents.dayOfMonthAndTime;
    }

    await _plugin.zonedSchedule(
      title.hashCode, // Unique ID based on title
      title,
      'Time to restock!',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'Reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchComponents,
    );
  }

  // ❌ Cancel a notification using the same ID (title.hashCode)
  static Future<void> cancelNotificationByTitle(String title) async {
    await _plugin.cancel(title.hashCode);
  }
}
