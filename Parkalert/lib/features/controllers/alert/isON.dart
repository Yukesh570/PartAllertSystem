import 'dart:convert';

import 'package:Parkalert/utils/storage/bluetoothStorage/bluetoothStorage.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/utils/storage/ringerStorage/ringerStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsOnController extends GetxController {
  RxList<bool> isOnList = <bool>[].obs;
  RxBool isLoading = true.obs; // <-- Add loading indicator

  @override
  void onInit() {
    super.onInit();
    loadIsOnFromStorage();
  }

  Future<void> loadIsOnFromStorage() async {
    // final prefs = await SharedPreferences.getInstance();
    // final List<String>? jsonStringList = prefs.getStringList('ringers');
    final List<RingerData> ringer = await loadRingers();
    final List<bool> extractedIsOnList = ringer
        .map((ring) => ring.isOn)
        .toList();

    isOnList.value = extractedIsOnList;
    //   print("📥 Loaded isOnList: $isOnList");
    // } else {
    //   print("⚠️ No saved ringer data found.");
    // }
    isLoading.value = false; // <-- loading done
  }

  void InitializeButton() {
    // Grow the list up to the required index
    // while (isOnList.length <= index) {
    //   isOnList.add(false); // Or any default value
    // }
    isOnList.add(false); // Adds a new button with isOn = false
  }

  void toggleSwitch(BuildContext context, RingerData ringerData) async {
    await activeBluetooth();
    print("Current isOnList: $isOnList");
    print("Any true? ${isOnList.any((on) => on)}");
    print(isOnList[ringerData.index]);
    if (isOnList[ringerData.index]) {}
    if (isOnList.any((on) => on) && !isOnList[ringerData.index]) {
      print("=== OBX RINGER SWITCH TOGGLED============");

      showDialog(
        context: context,

        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Switch Toggled"),
            content: Text(
              isOnList[ringerData.index]
                  ? "Ringer is now ON"
                  : "Ringer is now OFF",
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      isOnList[ringerData.index] = !isOnList[ringerData.index];

      await updateRingers(
        ringerData.index,
        isOnList[ringerData.index],
        null,
        null,
        null,
      );
      await activeBluetooth();
      var ujj = await loadActiveBluetooth();
      print("uuujjjjwwaaall:$ujj");
    }
  }
}
