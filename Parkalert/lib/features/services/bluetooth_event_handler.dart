import 'package:Parkalert/utils/storage/bluetoothStorage/bluetoothStorage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothEventHandler {
  static const platform = MethodChannel('bluetooth/events');

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    platform.setMethodCallHandler((MethodCall call) async {
      print(
        "Call:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::",
      );
      // final prefs = await SharedPreferences.getInstance();
      // final insideGeofence = prefs.getBool("flutter.insideGeofence") ?? false;
      // print("🚫 Inside geofence → skip notification${insideGeofence}");

      // if (insideGeofence) {
      //   print("🚫 Inside geofence → skip notification");
      //   return;
      // }
      if (call.method == 'onGalaxyBudsConnected') {
        print("Galaxy Buds+ connected! START");
        await showNotification('connected');
        print("Galaxy Buds+ connected! END");
      } else if (call.method == 'onGalaxyBudsDisconnected') {
        print("Galaxy Buds+ disconnected! START");
        await showNotification('disconnected');
        print("Galaxy Buds+ disconnected! END");
      }
    });
  }

  static Future<void> showNotification(String message) async {
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
        'Bluetooth $message',
        ujj['bluetooth'],
        platformSettings,
      );
    } catch (e, st) {
      print("❌ Error in showNotification: $e");
      print("📍 Stacktrace:\n$st");
    }
  }
}
