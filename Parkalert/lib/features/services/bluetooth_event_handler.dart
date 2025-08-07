import 'package:Parkalert/utils/storage/bluetoothStorage/bluetoothStorage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BluetoothEventHandler {
  static const platform = MethodChannel('bluetooth/events');
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    print(
      "==================================================================================================G123/* 1 */2312312===========================",
    );
    platform.setMethodCallHandler((MethodCall call) async {
      print(
        "Call:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::",
      );
      if (call.method == 'onGalaxyBudsConnected') {
        print("Galaxy Buds+ connected! START");
        await showNotification();
        print("Galaxy Buds+ connected! END");
      }
    });
  }

  static Future<void> showNotification() async {
    var ujj = await loadActiveBluetooth();
    if (ujj.trim().isEmpty) {
      print("No active Bluetooth device, skipping notification");
      return;
    }
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
      ujj,
      platformSettings,
    );
  }
}
