import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
import 'package:Parkalert/features/screen/navItems/freezones/freezone.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:latlong2/latlong.dart';

class FreezoneController extends GetxController {
  static FreezoneController get instance => Get.find();
  var zones = <ZoneData>[].obs;
  RxBool isLoading = true.obs; // <-- Add loading indicator

  RxList<bool> isOnList = <bool>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadZonesFromPrefs();
  }

  Future<void> loadZonesFromPrefs() async {
    zones.value = await loadZones();

    // 🔹 Rebuild isOnList so it matches zones
    isOnList.value = zones.map((z) => z.isOn).toList();

    isLoading.value = false; // done
  }

  Future<void> addZone(ZoneData newZone) async {
    await saveZones([newZone]);
    await loadZonesFromPrefs(); // refresh immediately
  }

  // Future<void> updateZone(int index, List<LatLng> points) async {
  //   await updateZones(index, isOn, name);
  //   await loadZonesFromPrefs();
  // }

  void InitializeButton() {
    // Grow the list up to the required index
    // while (isOnList.length <= index) {
    //   isOnList.add(false); // Or any default value
    // }
    isOnList.add(false); // Adds a new button with isOn = false
  }

  void toggleSwitch(BuildContext context, ZoneData zoneData) async {
    isOnList[zoneData.index] = !isOnList[zoneData.index];

    await updateZones(
      zoneData.index,
      isOnList[zoneData.index],
      null,
      null,
      null,
      null,
    );
  }
}
