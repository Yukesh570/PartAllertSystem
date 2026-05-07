import 'package:Parkalert/api/api.dart';
import 'package:Parkalert/api/apiservice.dart';
import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/helperWidget/sound.dart';
import 'package:Parkalert/features/screen/information/information.dart';
import 'package:Parkalert/features/screen/map/test.dart';
import 'package:Parkalert/features/services/bluetooth_event_handler.dart';
import 'package:Parkalert/gerofence_bt_service.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/services/notificatoinService.dart';
import 'package:Parkalert/utils/healper/permission.dart';
import 'package:flutter/material.dart';
import 'package:Parkalert/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!BACKENDAPI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await GetStorage.init();
//     print("✅ Workmanager task started: $task");
//     try {
//       await dotenv.load(fileName: ".env");

//       await backupHistory();
//       print("✅ backupHistory completed successfully");
//     } catch (e, s) {
//       print("❌ Error in backupHistory: $e");
//       print(s);
//     }
//     await Future.delayed(const Duration(seconds: 2));

//     return Future.value(true);
//   });
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(DrawerControllerX());

  // 1. MUST INITIALIZE ALARM MANAGER HERE FIRST
  // await AndroidAlarmManager.initialize();

  // 2. USE YOUR NEW "POP" CLASS NAME
  await NotificationServicepop.initialize();
  await NotificationServicepop().requestPermissions();

  // 3. LISTEN FOR BLUETOOTH
  // 3. LISTEN FOR BLUETOOTH
  // 3. LISTEN FOR BLUETOOTH
  // 3. LISTEN FOR BLUETOOTH
  // 3. LISTEN FOR BLUETOOTH
  // 3. LISTEN FOR BLUETOOTH
  const bluetoothChannel = MethodChannel('bluetooth/events');

  // Flag to prevent double popups
  bool isAlarmDialogShowing = false;

  bluetoothChannel.setMethodCallHandler((call) async {
    if (call.method == "triggerAlarmPopup") {
      // If it's already showing, ignore the double-tap!
      if (isAlarmDialogShowing) return;
      isAlarmDialogShowing = true;

      // ✅ 1. Get the context safely FIRST
      final context = Get.context;

      // ✅ 2. Check for Dark Mode safely
      final isDark = context != null
          ? Theme.of(context).brightness == Brightness.dark
          : false;

      // ✅ 3. Safely get localizations (fallback to English if not ready)
      final loc = context != null ? AppLocalizations.of(context) : null;

      // Extract data from Native Java
      final Map<dynamic, dynamic> args = call.arguments;
      String ringerJson = args['ringerJson'] ?? "";
      String deviceName = args['deviceName'] ?? "Unknown Device";
      bool connected = args['connected'] ?? true;

      // Show the upgraded, modern Flutter Popup Screen
      await Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wraps content perfectly
              children: [
                // 1. Modern Icon Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blueAccent.withOpacity(0.15)
                        : Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_car, // Car icon fits perfectly
                    size: 42,
                    color: isDark
                        ? Colors.blueAccent.shade100
                        : Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Bold Title (✅ USING YOUR NEW TRANSLATION)
                Text(
                  loc?.actionRequired ?? "Action Required",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // 3. Main Instruction
                // Text(
                //   "Please set your parking disc!", // You can translate this later too!
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //     color: isDark ? Colors.white70 : Colors.black54,
                //   ),
                // ),
                const SizedBox(height: 16),

                // 4. Sleek Device Info Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bluetooth_connected,
                        size: 18,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          deviceName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 5. High-Touch Buttons
                Row(
                  children: [
                    // Secondary Action: QUIT
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Colors.redAccent.shade200,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          Get.back();
                          await bluetoothChannel.invokeMethod(
                            'quitFromFlutter',
                          );
                        },
                        child: Text(
                          "QUIT", // You can translate this later too!
                          style: TextStyle(
                            color: isDark
                                ? Colors.redAccent.shade100
                                : Colors.redAccent.shade200,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Gap between buttons
                    // Primary Action: SNOOZE
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          Get.back();
                          await bluetoothChannel
                              .invokeMethod('snoozeFromFlutter', {
                                "ringerJson": ringerJson,
                                "deviceName": deviceName,
                                "connected": connected,
                              });
                        },
                        child: const Text(
                          "SNOOZE (5-Min)", // You can translate this later too!
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Reset the flag once the user clicks a button and the dialog closes
      isAlarmDialogShowing = false;
    }
  });
  await dotenv.load();
  runApp(const App());
}
