import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  Future<String> initialize() async {
    try {
      const androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const initSettings = InitializationSettings(
        android: androidSettings,
      );

      await _plugin.initialize(initSettings);

      return "Initialized";
    } catch (e) {
      return "Initialization error: $e";
    }
  }

  // DAILY notification
  Future<String> scheduleDailyNotification() async {
    try {
      await _plugin.periodicallyShow(
        1,
        'Daily Recipe Reminder',
        'Click to check today’s random meal!',
        RepeatInterval.daily,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_meal_channel',
            'Daily Meal Notifications',
            channelDescription: 'Sends daily reminder for a random recipe.',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      return "Daily notification scheduled!";
    } catch (e) {
      return "Error scheduling notification: $e";
    }
  }


  Future<void> showTestNotification() async {
    await _plugin.show(
      999,
      "Test Notification",
      "Im checking if notification is working!",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Used only for testing notifications.',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
