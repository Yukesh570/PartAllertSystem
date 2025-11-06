import 'dart:convert';
import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';

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

Future<void> overRideSilence(int index, bool overridesilence) async {
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

  // void printAllSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final keys = prefs.getKeys();

  //   if (keys.isEmpty) {
  //     print("SharedPreferences is asdasdasdasdasdas.");
  //     return;
  //   }

  //   print("SharedPreferences asdasdasdasdasdasda:");
  //   for (String key in keys) {
  //     final value = prefs.get(key);
  //     print("kale: $key → Value: $value");
  //   }
  // }

  // printAllSharedPreferences();
  await prefs.setStringList("ringers", updatedJsonList);
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
