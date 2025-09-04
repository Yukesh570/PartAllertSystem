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

Future<void> ensureLocationPermissions() async {
  // Step 1: Request foreground first
  var fg = await Permission.location.request();
  if (!fg.isGranted) {
    print("❌ Foreground location denied");
    return;
  }

  // Step 2: Request background ("Allow all the time")
  var bg = await Permission.locationAlways.request();
  if (!bg.isGranted) {
    print("⚠️ Background location denied");

    // If permanently denied, guide user to Settings
    if (await Permission.locationAlways.isPermanentlyDenied) {
      await openAppSettings();
    }
  } else {
    print("✅ Background location granted");
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
