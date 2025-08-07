import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static Future initialize() async {
    var androidInitialize = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    var iOSInitialize = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create notification channel for Android with custom sound
    await _createNotificationChannel(flutterLocalNotificationsPlugin);
  }

  static Future _createNotificationChannel(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'parkalert_channel2', // same id as used in showBigTextNotification
      'Parking Alert',
      description: 'Channel for parking alerts',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        'mixkit_wrong_answer_fail',
      ), // custom sound
    );

    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel);
    }
  }

  static Future showBigTextNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    print("Notification triggered");
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'parkalert_channel2', // channel id
          'Parking Alert',
          playSound: true,
          sound: RawResourceAndroidNotificationSound(
            "mixkit_wrong_answer_fail",
          ),
          importance: Importance.max,
          priority: Priority.high,
        );
    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    await fln.show(id, title, body, not);
  }

  Future<void> requestPermissions() async {
    // Only needed on Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}

List<String> soundList = [
  'abhash',
  'idiot',
  'sweta',
  'ujjwal',
  'nischal',
  'yugen',
  'yukesh',
  'yunik',
];

void showSoundPicker({
  required BuildContext context,
  required TextEditingController controller,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext ctx) {
      return ListView.builder(
        itemCount: soundList.length,
        itemBuilder: (context, index) {
          String sound = soundList[index];
          return ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(sound),
            onTap: () {
              controller.text = sound;
              Navigator.of(context).pop();
            },
          );
        },
      );
    },
  );
}
