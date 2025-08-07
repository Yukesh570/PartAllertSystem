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
    try {
      print("00000000000000000000000000 ${ujj}");
      if ((ujj['bluetooth'] ?? '').trim().isEmpty) {
        print("No active Bluetooth device, skipping notification");
        return;
      }
      print("dqqqqqqqqqqqqqqqqqqqqqqqqqqqqq ${ujj}");

      final androidSettings = AndroidNotificationDetails(
        'bluetooth_channel',
        'Bluetooth Events',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound((ujj['sound'] ?? '')),
      );
      print("2222222222222222222222222222222222222222222 ${ujj}");

      final platformSettings = NotificationDetails(android: androidSettings);
      print("333333333333333333333333333333333333333333 ${ujj}");

      await flutterLocalNotificationsPlugin.show(
        0,
        'Bluetooth Connected',
        ujj['bluetooth'],
        platformSettings,
      );
    } catch (e, st) {
      print("❌ Error in showNotification: $e");
      print("📍 Stacktrace:\n$st");
    }
  }
}
