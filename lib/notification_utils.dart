import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todolist/utils.dart' as utils;

class NotificationUtils {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOs = IOSInitializationSettings();
    const settings = InitializationSettings(iOS: iOs, android: android);
    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onSelectNotification: (payload) async {},
    );
  }

  static void scheduleNotificationWithDefaultSound(
      String name, DateTime deadline) async {
    final diff = deadline.difference(DateTime.now()).inMinutes;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      (deadline.millisecondsSinceEpoch / 1000).round(),
      'Deadline is comming in $diff minutes',
      '$name is due at ${utils.formatDateTime(deadline)}',
      tz.TZDateTime.from(
          deadline.subtract(Duration(minutes: diff > 10 ? 10 : diff)),
          tz.getLocation('Asia/Bangkok')),
      await _notificationDetails(),
      payload: 'Default_Sound',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }

  static void cancelNotification(int id) =>
      flutterLocalNotificationsPlugin.cancel(id);
}
