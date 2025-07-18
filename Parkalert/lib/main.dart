import 'package:flutter/material.dart';
import 'package:Parkalert/app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await dotenv.load();
  runApp(const App());
}
