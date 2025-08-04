import 'dart:convert';
import 'package:Parkalert/features/controllers/alert/isON.dart';
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

Future<void> updateRingers(
  int index,
  bool isOn,
  String? name,
  String? bluetooth,
  String? sound,
) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('ringers');

  List<RingerData> allRingers = existingJsonList!
      .map((jsonStr) => RingerData.fromJson(jsonDecode(jsonStr)))
      .toList();

  print("All ringers: ${allRingers.length}");

  int indexToUpdate = allRingers.indexWhere((r) => r.index == index);

  print("Index to update: $indexToUpdate");

  if (indexToUpdate != -1) {
    if (name == null && bluetooth == null && sound == null) {
      allRingers[indexToUpdate].isOn = isOn;
    } else {
      allRingers[indexToUpdate].isOn = isOn;
      allRingers[indexToUpdate].name = name!;
      allRingers[indexToUpdate].bluetooth = bluetooth!;
      allRingers[indexToUpdate].sound = sound!;
    }
  } else {
    print("Ringer with index ${index} not found");
  }

  List<String> updatedJsonList = allRingers
      .map((r) => jsonEncode(r.toJson()))
      .toList();
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
      print("kale: $key → Value: $value");
    }
  }

  printAllSharedPreferences();
  await prefs.setStringList("ringers", updatedJsonList);
}
