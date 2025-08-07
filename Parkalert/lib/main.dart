import 'package:Parkalert/features/screen/helperWidget/sound.dart';
import 'package:Parkalert/features/screen/information/information.dart';
import 'package:Parkalert/features/services/bluetooth_event_handler.dart';
import 'package:flutter/material.dart';
import 'package:Parkalert/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await NotificationService.initialize();

  await NotificationService().requestPermissions();
  BluetoothEventHandler.initialize();

  await dotenv.load();
  runApp(const App());
}
