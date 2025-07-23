import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static Future initialize(
    FlutterLocalNotificationsPlugin FlutterLocalNotificationsPlugin,
  ) async {
    var androidInitialize = new AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    var iOSInitialize = new DarwinInitializationSettings();
    var initializtionsSettings = new InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    await FlutterLocalNotificationsPlugin.initialize(initializtionsSettings);
  }

  static Future showBigTextNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    print("objecsdsdsdt");
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
          'parkalert_channel2',
          'Parking Alert',
          playSound: true,
          sound: RawResourceAndroidNotificationSound("mixkit_bell"),
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
  'mixkit_bell',
  'mixkit_correct',
  'mixkit_interface_option',
  'mixkit_long_pop',
  'mixkit_sci_fi_click',
  'mixkit_software_interface_back',
  'mixkit_wrong_answer_fail',
];
void showSoundPicker({
  required BuildContext context,
  required TextEditingController controller,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext ctx) {
      //context is the BuildContext for the widget being built. It gives access to surrounding widget info (theme, navigation, etc.) and is crucial for building widgets dynamically and responsively.
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
