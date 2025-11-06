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

//   print("All permissions granted");
// }
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermissions(BuildContext context) async {
  // Request foreground first

  final isDark = Theme.of(context).brightness == Brightness.dark;

  final loc = AppLocalizations.of(context);
  if (loc == null) {
    // If localization is not available, we cannot proceed with localized strings.
    debugPrint(
      "Localization context is null. Cannot display localized dialog.",
    );
    return;
  }
  var loca = await Permission.location.request();
  if (!loca.isGranted) {
    debugPrint("Foreground location denied");
    return;
  }

  // Request background
  var bg = await Permission.locationAlways.request();
  if (!bg.isGranted) {
    debugPrint("Background location denied");

    // Show explanation dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,

        title: Text(
          loc.allowlocation,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          loc.allowlocationparagraph,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              loc.cancel,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,

                fontSize: 18, // 👈 Bigger text
                fontWeight: FontWeight.w600, // 👈 Semi-bold
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings(); // send user to settings
            },
            child: Text(
              loc.opensettings,
              style: TextStyle(
                color: isDark ? Colors.blue[300] : Colors.blue,

                fontSize: 18, // 👈 Bigger text
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    debugPrint("Background location granted");
  }
}
