import 'dart:convert';

import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/navItems/freeZone_controller.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/alertFrom.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/screen/helperWidget/sound.dart';
import 'package:Parkalert/features/screen/navItems/activity/activityBox.dart';
import 'package:Parkalert/features/screen/navItems/freezones/zoneBox.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/data/historyData.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({super.key});

  @override
  State<ActivityHistory> createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  final zoneController = Get.put(FreezoneController());
  List<Historydata> _history = [];
  bool _loadingHistory = true;

  Future<void> loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("currentLocation") ?? "[]";

    final List<dynamic> jsonList = json.decode(jsonString);

    final historyList = jsonList.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value as Map<String, dynamic>;
      return Historydata.fromJson({
        "index": index,
        "lat": item["lat"],
        "lng": item["lng"],
        "time": item["time"].toString(),
        "name": item["name"],
      });
    }).toList();

    setState(() {
      _history = historyList;
      _loadingHistory = false;
    });
  }

  @override
  void initState() {
    super.initState();
    zoneController.loadZonesFromPrefs();
    loadSavedLocations();
  }

  final TextEditingController _nameController = TextEditingController();

  Widget build(BuildContext context) {
    final drawerCtrl = Get.find<DrawerControllerX>();
    print(
      "qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq${_history}",
    );

    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final MainController controller = Get.put(MainController());

    void printAllSharedPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      final zones = prefs.getStringList('zones');

      if (zones == null || zones.isEmpty) {
        print("🔍 No zones found in SharedPreferences.");
        return;
      }

      print("🔐 Saved Zones:");
      for (var i = 0; i < zones.length; i++) {
        print("Zone $i → ${zones[i]}");
      }
    }

    printAllSharedPreferences();
    _addZone({
      required String name,
      required String initialTime,
      required String stopTime,
      required bool isOn,
    }) async {
      final newIndex = zoneController.zones.length;
      await zoneController.addZone(
        ZoneData(
          index: newIndex,
          initialTime: initialTime, // or get from UI
          stopTime: stopTime, // or get from UI
          isOn: isOn,
          name: name,
          points: [],
        ),
      );
    }

    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return PageWrapper(
      routeName: '/activity', // current route

      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: dark ? Colors.black : Colors.white, // 👈 Add this

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          title: Text(
            "Activity History",
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
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
            ),

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
                        'Set Alert Zone',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Main alert settings card
                    Expanded(
                      child: Obx(() {
                        if (zoneController.zones.isEmpty) {
                          return const Center(
                            child: Text(
                              'No History Found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: _history
                                .map(
                                  (data) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ActivityBox(historydata: data),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ), // Space before bottom navigation
                  ],
                ),
              ),
            ),
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
                        drawerCtrl.goBack(); // update drawer highlight

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
                        controller.alertPage();
                      },
                      context: context,
                    ),
                    addAlertButton(context: context, onPressed: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
