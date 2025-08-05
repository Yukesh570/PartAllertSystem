import 'dart:convert';

import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/features/controllers/navItems/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/alertFrom.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/screen/navItems/alert/ringers.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:Parkalert/utils/storage/ringerStorage/ringerStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

var ringersList = <Ringers>[].obs;
List<Ringers> ringersListdemo = [];

class _AlertState extends State<Alert> {
  @override
  void initState() {
    super.initState();
    loadAndSetRingers();
    final isOnController = Get.put(IsOnController());
    isOnController.loadIsOnFromStorage();
  }

  void loadAndSetRingers() async {
    List<RingerData> savedRingers = await loadRingers();

    setState(() {
      ringersListdemo = savedRingers
          .map((data) => Ringers(ringerData: data))
          .toList();

      ringersList.value = savedRingers
          .map((data) => Ringers(ringerData: data))
          .toList();
    });
    print("ringersList: $ringersListdemo");
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    ;
    void printAllSharedPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      if (keys.isEmpty) {
        print("🔍 SharedPreferences is empty.");
        return;
      }

      print("🔐 SharedPreferences Contents:");
      for (String key in keys) {
        final value = prefs.get(key);
        print("yjkesh: $key → Value: $value");
      }
    }

    printAllSharedPreferences();

    final dark = Theme.of(context).brightness == Brightness.dark;
    bool isOn = false;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: Text(loc.alerts, style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
          ),
        ),
      ),
      drawer: const navButton(),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
          ),
          // other children here...
          Padding(
            padding: const EdgeInsets.only(
              top: 0,
              bottom: 0,
              right: 22,
              left: 22,
            ),
            child: Container(
              width: double.infinity,
              height: 680,
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 10.0,
              ),
              decoration: BoxDecoration(
                color: dark
                    ? const Color.fromARGB(255, 34, 34, 34)
                    : const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Set your Alert" and "My Alerts" text
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Text(
                      'Setup your ringers',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Text(
                      'My Alerts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (ringersList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),

                      child: Padding(
                        padding: EdgeInsets.only(top: 200.0),
                        child: Center(
                          child: Text(
                            'No Ringers',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Main alert settings card
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        child: Column(
                          children: ringersList
                              .map(
                                (ringer) => (Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ringer,
                                )),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ), // Space before bottom navigation
                ],
              ),
            ),
          ),
          // Bottom navigation buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCircularIconButton(
                    context: context,
                    icon: Icons.arrow_back,
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        // Optionally handle the case where there's no back route
                        print("No screen to go back to");
                      }
                    },
                  ),
                  buildMainButton(
                    text: 'Main',
                    onPressed: () {
                      /* Handle Main */
                    },
                    context: context,
                  ),
                  buildCircularAddbButton(
                    context: context,
                    onPressed: () {
                      controller.alertSettingPage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
