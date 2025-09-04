// import 'package:permission_handler/permission_handler.dart';

// Future<void> requestPermissions() async {
//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.location,
//     Permission.locationAlways, // Requests ACCESS_BACKGROUND_LOCATION on Android
//     Permission.bluetooth,
//     Permission.bluetoothScan,
//     Permission.bluetoothConnect,
//     Permission.notification,
//   ].request();

//   // Log permission statuses
//   print("Location: ${statuses[Permission.location]}");
//   print("Location Always: ${statuses[Permission.locationAlways]}");
//   print("Bluetooth: ${statuses[Permission.bluetooth]}");
//   print("Bluetooth Scan: ${statuses[Permission.bluetoothScan]}");
//   print("Bluetooth Connect: ${statuses[Permission.bluetoothConnect]}");
//   print("Notification: ${statuses[Permission.notification]}");

//   // Check if any permissions are denied
//   if (statuses[Permission.location]!.isDenied) {
//     print("Location permission denied");
//   }
//   if (statuses[Permission.locationAlways]!.isDenied) {
//     print("Background location permission denied");
//   }
//   if (statuses[Permission.bluetooth]!.isDenied ||
//       statuses[Permission.bluetoothScan]!.isDenied ||
//       statuses[Permission.bluetoothConnect]!.isDenied) {
//     print("Bluetooth permissions denied");
//   }
//   if (statuses[Permission.notification]!.isDenied) {
//     print("Notification permission denied");
//   }
// }

// import 'package:permission_handler/permission_handler.dart';

// Future<void> requestPermissions() async {
//   // Step 1: Foreground location
//   var loc = await Permission.location.request();
//   if (!loc.isGranted) {
//     if (loc.isPermanentlyDenied) {
//       openAppSettings();
//     }
//     return;
//   }

//   // Step 2: Background location
//   var bgLoc = await Permission.locationAlways.request();
//   if (!bgLoc.isGranted) {
//     if (bgLoc.isPermanentlyDenied) {
//       openAppSettings();
//     }
//     return;
//   }

//   // Step 3: Bluetooth (Android 12+)
//   var btScan = await Permission.bluetoothScan.request();
//   var btConnect = await Permission.bluetoothConnect.request();
//   if (!btScan.isGranted || !btConnect.isGranted) {
//     if (btScan.isPermanentlyDenied || btConnect.isPermanentlyDenied) {
//       openAppSettings();
//     }
//     return;
//   }

//   // Step 4: Notifications
//   var notif = await Permission.notification.request();
//   if (!notif.isGranted) {
//     if (notif.isPermanentlyDenied) {
//       openAppSettings();
//     }
//     return;
//   }

//   print("✅ All permissions granted");
// }
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermissions(BuildContext context) async {
  // Request foreground first
  var loc = await Permission.location.request();
  if (!loc.isGranted) {
    debugPrint("❌ Foreground location denied");
    return;
  }

  // Request background
  var bg = await Permission.locationAlways.request();
  if (!bg.isGranted) {
    debugPrint("⚠️ Background location denied");

    // Show explanation dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Allow 'All the time' Location"),
        content: const Text(
          "To detect Bluetooth events and geofences even when the app is closed, "
          "please enable 'Allow all the time' in Settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings(); // send user to settings
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  } else {
    debugPrint("✅ Background location granted");
  }
}
