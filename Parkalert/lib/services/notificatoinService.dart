import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

// 1. MUST BE TOP LEVEL AND STATIC
@pragma('vm:entry-point')
void alarmTriggerCallback() async {
  print("⏰ AlarmManager fired! Waking up the notification...");
  await GetStorage.init();
  final String? data = GetStorage().read('last_ringer_json');
  if (data != null) {
    // NotificationServicepop().showAlarmPopup(data);
  }
}

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) async {
  if (response.actionId == 'snooze_action') {
    print("SNOOZE: Scheduling via AndroidAlarmManager for 10 seconds");

    // Close the current notification immediately so the user knows they clicked it
    FlutterLocalNotificationsPlugin().cancel(999);

    // This tells the Android OS to wake us up in 10 seconds
    await AndroidAlarmManager.oneShot(
      const Duration(seconds: 10),
      123, // Unique ID
      alarmTriggerCallback,
      exact: true,
      wakeup: true,
    );
  } else if (response.actionId == 'quit_action') {
    print("QUIT: Stopping alarms");
    await GetStorage.init();
    GetStorage().remove('last_ringer_json');
    FlutterLocalNotificationsPlugin().cancel(999);
  }
}

class NotificationServicepop {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await AndroidAlarmManager.initialize(); // Initialize Alarm Manager

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // Future<void> showAlarmPopup(String ringerJson) async {
  //   await GetStorage.init();
  //   GetStorage().write('last_ringer_json', ringerJson);

  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //         'park_alarm_id',
  //         'Park Alarm Alerts',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         fullScreenIntent: true,
  //         ongoing: true,
  //         actions: <AndroidNotificationAction>[
  //           AndroidNotificationAction(
  //             'snooze_action',
  //             'SNOOZE',
  //             cancelNotification:
  //                 true, // 👈 Closes it silently without opening app
  //           ),
  //           AndroidNotificationAction(
  //             'quit_action',
  //             'QUIT',
  //             cancelNotification: true, // 👈 Closes it silently
  //           ),
  //         ],
  //       );

  //   await _notificationsPlugin.show(
  //     999,
  //     'ParkAlarm Action Required',
  //     'Please set your parking disc!',
  //     const NotificationDetails(android: androidDetails),
  //   );
  // }

  Future<void> requestPermissions() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    // 1. Ask for standard Notification Permissions (Required for Android 13+)
    await androidImplementation?.requestNotificationsPermission();

    // 2. Ask for Full Screen Intent (Required for Popups)
    // await androidImplementation?.requestFullScreenIntentPermission();

    // 3. Ask for Exact Alarms (Required for Android 14+ background timers)
    await androidImplementation?.requestExactAlarmsPermission();
  }
}
