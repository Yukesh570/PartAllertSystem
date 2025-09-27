import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // your app icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel', // channel id
          'Default Channel', // channel name
          channelDescription: 'Channel for test notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('test'), // 👈 without .wav
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'ParkAlert',
      'This is a test notification!',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return PageWrapper(
      routeName: '/questions',

      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: dark ? Colors.black : Colors.white, // 👈 Add this

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          title: Text(
            loc.howParkAlertWorks,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
            ),
          ),
        ),
        drawer: const navButton(),
        body: SafeArea(
          minimum: const EdgeInsets.only(bottom: 12.0),

          child: SafeArea(
            minimum: const EdgeInsets.only(bottom: 12.0),

            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
                ),

                // other children here...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
