import 'package:Parkalert/features/screen/helperWidget/sound.dart';
import 'package:flutter/material.dart';
import 'package:Parkalert/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await NotificationService.initialize(flutterLocalNotificationsPlugin);

  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
// import 'package:Parkalert/features/screen/helperWidget/sound.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void main() {
//   WidgetsFlutterBinding.ensureInitialized(); // ✅ Add this

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State createState() => _HomePageState();
// }

// class _HomePageState extends State {
//   @override
//   void initState() {
//     super.initState();
//     NotificationService.initialize(flutterLocalNotificationsPlugin);
//     NotificationService().requestPermissions(); // ADD THIS
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF3ac3cb), Color(0xFFf85187)],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(backgroundColor: Colors.blue.withOpacity(0.5)),
//         body: Center(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             width: 200,
//             height: 80,
//             child: ElevatedButton(
//               onPressed: () {
//                 NotificationService.showBigTextNotification(
//                   title: "New message title",
//                   body: "Your long body",
//                   fln: flutterLocalNotificationsPlugin,
//                 );
//               },
//               child: Text("click"),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
