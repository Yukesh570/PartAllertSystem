import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/navItems/main_controller.dart';
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Freezone extends StatefulWidget {
  const Freezone({super.key});

  @override
  State<Freezone> createState() => _FreezoneState();
}

var zonesList = <ZoneBox>[].obs;
List<ZoneBox> zonesListdemo = [];

class _FreezoneState extends State<Freezone> {
  @override
  void initState() {
    super.initState();
    loadAndSetZones();
    final isOnController = Get.put(IsOnController());
    isOnController.loadIsOnFromStorage();
  }

  final TextEditingController _nameController = TextEditingController();
  void loadAndSetZones() async {
    List<ZoneData> savedRingers = await loadZones();

    setState(() {
      zonesListdemo = savedRingers
          .map((data) => ZoneBox(zoneData: data))
          .toList();

      zonesList.value = savedRingers
          .map((data) => ZoneBox(zoneData: data))
          .toList();
    });
    print("zonesList: $zonesListdemo");
  }

  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final MainController controller = Get.put(MainController());

    List<ZoneData> zoneDataList = [];

    _addZone({
      required String name,
      required String initialTime,
      required String stopTime,
      required bool isOn,
    }) async {
      final List<ZoneData> savedZoneData = await loadZones();

      final newIndex = savedZoneData.length;
      ZoneData newZoneData = ZoneData(
        index: newIndex,
        initialTime: initialTime, // or get from UI
        stopTime: stopTime, // or get from UI
        isOn: isOn,
        name: name,
      );
      zoneDataList.add(newZoneData);
      print('sdfsdfsdfsdfdsfsflakckkk ${zoneDataList.length}');
      await saveZones(zoneDataList);
    }

    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,

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
                  if (zonesList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),

                      child: Padding(
                        padding: EdgeInsets.only(top: 200.0),
                        child: Center(
                          child: Text(
                            'No ZoneBox',
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
                          children: zonesList
                              .map(
                                (zone) => (Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: zone,
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
                  addAlertButton(
                    context: context,
                    onPressed: () async {
                      await _addZone(
                        name: "FreeZone",
                        initialTime: "currentDate",
                        stopTime: "currentTime", // or get from UI
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
    );
  }
}
