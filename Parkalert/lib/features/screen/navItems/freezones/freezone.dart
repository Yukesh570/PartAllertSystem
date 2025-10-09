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
import 'package:Parkalert/features/screen/navItems/freezones/zoneBox.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Freezone extends StatefulWidget {
  const Freezone({super.key});

  @override
  State<Freezone> createState() => _FreezoneState();
}

class _FreezoneState extends State<Freezone> {
  final zoneController = Get.put(FreezoneController());

  @override
  void initState() {
    super.initState();
    zoneController.loadZonesFromPrefs();
  }

  final TextEditingController _nameController = TextEditingController();

  Widget build(BuildContext context) {
    final drawerCtrl = Get.find<DrawerControllerX>();

    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final MainController controller = Get.put(MainController());
    // void printAllSharedPreferences() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   final zones = prefs.getStringList('zones');

    //   if (zones == null || zones.isEmpty) {
    //     print("🔍 No zones found in SharedPreferences.");
    //     return;
    //   }

    //   print("🔐 Saved Zones:");
    //   for (var i = 0; i < zones.length; i++) {
    //     print("Zone $i → ${zones[i]}");
    //   }
    // }

    // printAllSharedPreferences();
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
      routeName: '/freezone', // current route

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,

        backgroundColor: dark ? Colors.black : Colors.white, // 👈 Add this

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          title: Text(
            loc.freezones,
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
          child: Stack(
            children: [
              // 🔹 Fixed background
              Positioned.fill(
                child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
              ),

              // 🔹 Scrollable zone list container
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 12.0,
                ),
                child: GestureDetector(
                  // onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    width: double.infinity,
                    height: 670,
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: dark ? const Color(0xFF222222) : Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            loc.createzonewhereparkalarmwillbequit,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            loc.freezones,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // 🔹 Only the zone list scrolls
                        Expanded(
                          child: Obx(() {
                            if (zoneController.isLoading.value) {
                              // 🌀 Show loading spinner while data loads
                              return const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 12),
                                    // Text(
                                    //   "Loading Free Zones...",
                                    //   style: TextStyle(
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              );
                            }
                            if (zoneController.zones.isEmpty) {
                              return Center(
                                child: Text(
                                  loc.nozonebox,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                    20,
                              ),
                              child: Column(
                                children: zoneController.zones
                                    .map(
                                      (data) => Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ZoneBox(zoneData: data),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // 🔹 Fixed bottom buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCircularIconButton(
                        context: context,
                        icon: Icons.arrow_back,
                        onPressed: () {
                          drawerCtrl.goBack();
                          if (Navigator.of(context).canPop())
                            Navigator.of(context).pop();
                        },
                      ),
                      buildMainButton(
                        text: loc.main,
                        onPressed: () {
                          controller.alertPage();
                        },
                        context: context,
                      ),
                      addAlertButton(
                        context: context,
                        onPressed: () async {
                          await _addZone(
                            name:
                                "${loc.freezones} ${zoneController.zones.length + 1}",
                            initialTime: "--:--",
                            stopTime: "--:--",
                            isOn: false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
