import 'package:Parkalert/api/api.dart';
import 'package:Parkalert/api/apiservice.dart';
import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/helperWidget/sound.dart';
import 'package:Parkalert/features/screen/information/information.dart';
import 'package:Parkalert/features/screen/map/test.dart';
import 'package:Parkalert/features/services/bluetooth_event_handler.dart';
import 'package:Parkalert/gerofence_bt_service.dart';
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
  Get.put(DrawerControllerX()); // 👈 this is key
  // await Future.delayed(Duration(seconds: 2));

  await NotificationService.initialize();

  await NotificationService().requestPermissions();
  // GeofenceBtService.initListener();

  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!BACKENDAPI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Schedule every 5 days (5 * 24 * 60 = 7200 minutes)
  // Workmanager().registerPeriodicTask(
  //   "syncHistoriesTask",
  //   "syncHistories",
  //   // frequency: Duration(days: 5),
  //   // initialDelay: Duration(seconds: 10), // first run delay
  //   initialDelay: Duration(minutes: 1),

  //   constraints: Constraints(
  //     networkType: NetworkType.connected, // only when internet available
  //   ),
  // );

  // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //   listenForGeofenceEvents();
  //   await ensureLocationPermissions();
  // });
  await dotenv.load();
  runApp(const App());
}
