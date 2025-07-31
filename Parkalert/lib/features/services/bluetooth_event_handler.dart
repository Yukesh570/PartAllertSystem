import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BluetoothEventHandler {
  static const platform = MethodChannel('bluetooth/events');
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    print("G12312312312===========================");
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onGalaxyBudsConnected') {
        print(
          "Galaxy Buds+ connected!============================================",
        );
        _showNotification();
      }
    });
  }

  static Future<void> _showNotification() async {
    const androidSettings = AndroidNotificationDetails(
      'bluetooth_channel',
      'Bluetooth Events',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const platformSettings = NotificationDetails(android: androidSettings);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Bluetooth Connected',
      'Galaxy Buds+ connected!',
      platformSettings,
    );
  }
}
