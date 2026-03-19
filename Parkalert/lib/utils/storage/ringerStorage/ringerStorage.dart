import 'dart:convert';
import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:permission_handler/permission_handler.dart';

//saves the ringers
Future<bool> saveRingers(List<RingerData> ringers) async {
  final prefs = await SharedPreferences.getInstance();
  // Load existing ringers from SharedPreferences
  List<String>? existingJsonList = prefs.getStringList('ringers');
  List<RingerData> allRingers = [];

  if (existingJsonList != null) {
    allRingers = existingJsonList
        .map((jsonStr) => RingerData.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  // Avoid duplicate indices if needed
  for (var newringer in ringers) {
    if (!allRingers.any((r) => r.index == newringer.index)) {
      allRingers.add(newringer);
    }
  }

  // Save merged list back
  List<String> mergeJsonList = allRingers
      .map((r) => jsonEncode(r.toJson()))
      .toList();
  return await prefs.setStringList('ringers', mergeJsonList);
}

Future<List<RingerData>> loadRingers() async {
  final prefs = await SharedPreferences.getInstance();

  List<String>? jsonList = prefs.getStringList('ringers');

  if (jsonList == null) return [];

  return jsonList.map((jsonStr) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return RingerData.fromJson(jsonMap);
  }).toList();
}

Future<void> overRideSilence(
  int index,
  bool overridesilence,
  BuildContext context,
) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('ringers');
  List<RingerData> allRingers = existingJsonList!
      .map((jsonStr) => RingerData.fromJson(jsonDecode(jsonStr)))
      .toList();

  int indexToUpdate = allRingers.indexWhere((r) => r.index == index);

  if (indexToUpdate != -1) {
    allRingers[indexToUpdate].overRideSilence = overridesilence;
  } else {
    print("Ringer with index ${index} not found");
  }
  List<String> updatedJsonList = allRingers
      .map((r) => jsonEncode(r.toJson()))
      .toList();

  await prefs.setStringList("ringers", updatedJsonList);
  if (overridesilence) {
    await checkAndRequestDndPermission(context);
  }
}

Future<void> triggerTypeOption(
  int index,
  String triggerType,
  BuildContext context,
) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('ringers');
  List<RingerData> allRingers = existingJsonList!
      .map((jsonStr) => RingerData.fromJson(jsonDecode(jsonStr)))
      .toList();

  int indexToUpdate = allRingers.indexWhere((r) => r.index == index);

  if (indexToUpdate != -1) {
    allRingers[indexToUpdate].triggerType = triggerType;
  } else {
    print("Ringer with index ${index} not found");
  }
  List<String> updatedJsonList = allRingers
      .map((r) => jsonEncode(r.toJson()))
      .toList();

  await prefs.setStringList("ringers", updatedJsonList);
}

Future<void> checkAndRequestDndPermission(BuildContext context) async {
  // Only needed for Android M (API 23) and above
  if (Theme.of(context).platform == TargetPlatform.android) {
    try {
      // Check current permission state
      final status = await Permission.accessNotificationPolicy.status;

      if (!status.isGranted) {
        // Launch Android settings to grant DND access
        final intent = AndroidIntent(
          action: 'android.settings.NOTIFICATION_POLICY_ACCESS_SETTINGS',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();

        debugPrint("⚙️ Asking user to grant DND permission...");
      } else {
        debugPrint("✅ DND permission already granted");
      }
    } catch (e) {
      debugPrint("❌ Error requesting DND permission: $e");
    }
  }
}

Future<void> vibrationOption(int index, bool vibration) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('ringers');
  List<RingerData> allRingers = existingJsonList!
      .map((jsonStr) => RingerData.fromJson(jsonDecode(jsonStr)))
      .toList();

  int indexToUpdate = allRingers.indexWhere((r) => r.index == index);

  if (indexToUpdate != -1) {
    allRingers[indexToUpdate].vibration = vibration;
  }
  List<String> updatedJsonList = allRingers
      .map((r) => jsonEncode(r.toJson()))
      .toList();

  await prefs.setStringList("ringers", updatedJsonList);
}

Future<void> updateRingers(
  int index,
  bool? isOn,
  String? name,
  String? bluetooth,
  String? sound,
) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('ringers');

  List<RingerData> allRingers = existingJsonList!
      .map((jsonStr) => RingerData.fromJson(jsonDecode(jsonStr)))
      .toList();

  int indexToUpdate = allRingers.indexWhere((r) => r.index == index);
  if (indexToUpdate != -1) {
    if (name == null && bluetooth == null && sound == null) {
      allRingers[indexToUpdate].isOn = isOn!;
    } else if (isOn == null) {
      // allRingers[indexToUpdate].isOn = isOn!;
      allRingers[indexToUpdate].name = name!;
      allRingers[indexToUpdate].bluetooth = bluetooth!;
      allRingers[indexToUpdate].sound = sound!;
    }
  }

  List<String> updatedJsonList = allRingers
      .map((r) => jsonEncode(r.toJson()))
      .toList();

  await prefs.setStringList("ringers", updatedJsonList);
}

Future<void> deleteRinger(int index) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('ringers');
  await prefs.remove('activeBluetooth');

  if (existingJsonList == null) return;

  // Convert to RingerData list
  List<RingerData> allRingers = existingJsonList
      .map((jsonStr) => RingerData.fromJson(jsonDecode(jsonStr)))
      .toList();

  // Remove the ringer with the given index
  allRingers.removeWhere((r) => r.index == index);

  // Reassign indices to keep them continuous starting from 0
  for (int i = 0; i < allRingers.length; i++) {
    allRingers[i].index = i;
  }

  // Save the updated list back to SharedPreferences
  List<String> updatedJsonList = allRingers
      .map((r) => jsonEncode(r.toJson()))
      .toList();
  await prefs.setStringList('ringers', updatedJsonList);
  final isOnController = Get.find<IsOnController>();
  isOnController.loadIsOnFromStorage();
}
