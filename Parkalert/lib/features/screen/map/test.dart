import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

const geofenceChannel = MethodChannel('geofence/events');

Future<void> requestGeofencePermissions() async {
  await [
    Permission.location,
    Permission.locationAlways, // background
    Permission.notification, // Android 13+
  ].request();
}

/// Start the native ForegroundService for geofencing
Future<void> startGeofenceService() async {
  try {
    print("✅✅✅✅✅✅✅5464564565464564✅✅✅✅✅✅✅✅✅✅✅✅");

    await geofenceChannel.invokeMethod("startGeofenceService");
  } catch (e) {
    print("Error starting geofence service: $e");
  }
}

/// Stop the native ForegroundService for geofencing
Future<void> stopGeofenceService() async {
  try {
    await geofenceChannel.invokeMethod("stopGeofenceService");
  } catch (e) {
    print("Error stopping geofence service: $e");
  }
}

/// Listen for geofence events (enteredZone/exitedZone)
void listenForGeofenceEvents() {
  print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅");

  geofenceChannel.setMethodCallHandler((call) async {
    switch (call.method) {
      case "enteredZone":
        print("✅✅✅ Entered geofence zone");
        break;
      case "exitedZone":
        print("🚪⚠️⚠️⚠️ Exited geofence zone");
        break;
      default:
        print("⚠️ Unknown geofence event: ${call.method}");
    }
  });
}
