import 'package:Parkalert/features/screen/information/information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NotificationHome());
  }
}

class NotificationHome extends StatelessWidget {
  const NotificationHome({super.key});

  void showTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Title',
      'Test Body',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(title: const Text('Local Notification Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: showTestNotification,
          child: const Text('Show Test Notification'),
        ),
      ),
    );
  }
}
