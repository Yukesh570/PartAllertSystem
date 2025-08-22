import 'dart:convert';
import 'package:Parkalert/features/controllers/navItems/freeZone_controller.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

// saves the Zones
Future<bool> saveZones(List<ZoneData> zones) async {
  final prefs = await SharedPreferences.getInstance();

  List<String>? existingJsonList = prefs.getStringList('zones');
  List<ZoneData> allZones = [];

  if (existingJsonList != null) {
    allZones = existingJsonList
        .map((jsonStr) => ZoneData.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  // Avoid duplicate indices if needed
  for (var newZone in zones) {
    if (!allZones.any((r) => r.index == newZone.index)) {
      allZones.add(newZone);
    }
  }

  // Save merged list back
  List<String> mergeJsonList = allZones
      .map((r) => jsonEncode(r.toJson()))
      .toList();
  return prefs.setStringList('zones', mergeJsonList);
}

Future<List<ZoneData>> loadZones() async {
  final prefs = await SharedPreferences.getInstance();

  List<String>? jsonList = prefs.getStringList('zones');

  if (jsonList == null) return [];

  return jsonList.map((jsonStr) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return ZoneData.fromJson(jsonMap);
  }).toList();
}

Future<void> updateZones(
  int index,
  bool? isOn,
  List<LatLng>? points,
  String? name,
  String? initialTime,
  String? stopTime,
) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('zones');

  List<ZoneData> allZones = existingJsonList!
      .map((jsonStr) => ZoneData.fromJson(jsonDecode(jsonStr)))
      .toList();

  int indexToUpdate = allZones.indexWhere((r) => r.index == index);

  if (indexToUpdate != -1) {
    if (isOn != null) {
      allZones[indexToUpdate].isOn = isOn;
    } else if (points != null) {
      allZones[indexToUpdate].points = points;
    } else if (initialTime != null) {
      allZones[indexToUpdate].initialTime = initialTime;
    } else if (stopTime != null) {
      allZones[indexToUpdate].stopTime = stopTime;
    } else if (points != null && name != null) {
      allZones[indexToUpdate].points = points;
      allZones[indexToUpdate].name = name;
      print("Index to update: $indexToUpdate");
    } else if (name != null) {
      print("kkkkkkkakaaaaaalllllllllllleeeeeeeeeeee");
      allZones[indexToUpdate].name = name;
    }
  }
  List<String> updatedJsonList = allZones
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
      print("kale=======: $key → Value: $value");
    }
  }

  printAllSharedPreferences();
  await prefs.setStringList("zones", updatedJsonList);
}

Future<void> deleteZone(int index) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('zones');

  if (existingJsonList == null) return;

  // Convert to ZoneData list
  List<ZoneData> allZones = existingJsonList
      .map((jsonStr) => ZoneData.fromJson(jsonDecode(jsonStr)))
      .toList();

  // Remove by index
  allZones.removeWhere((zone) => zone.index == index);
  // 🔹 Reassign indices so they are continuous
  for (int i = 0; i < allZones.length; i++) {
    allZones[i].index = i; // ✅ start from 0
  }
  // Save back
  List<String> updatedJsonList = allZones
      .map((zone) => jsonEncode(zone.toJson()))
      .toList();
  await prefs.setStringList("zones", updatedJsonList);
  FreezoneController.instance.loadZonesFromPrefs();
}

// import 'dart:convert';
// import 'package:Parkalert/utils/storage/data/ZoneData.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // -------------------- SAVE --------------------
// Future<bool> saveZones(List<ZoneData> zones) async {
//   final prefs = await SharedPreferences.getInstance();

//   String jsonString = jsonEncode(
//     zones.map((z) => z.toJson()).toList(),
//   ); // encode as array

//   return prefs.setString('zones', jsonString); // ✅ single JSON string
// }

// // -------------------- LOAD --------------------
// Future<List<ZoneData>> loadZones() async {
//   final prefs = await SharedPreferences.getInstance();
//   String? jsonString = prefs.getString('zones');

//   if (jsonString == null || jsonString.isEmpty) return [];

//   List<dynamic> jsonArray = jsonDecode(jsonString);
//   return jsonArray.map((jsonMap) => ZoneData.fromJson(jsonMap)).toList();
// }

// // -------------------- UPDATE --------------------
// Future<void> updateZones(
//   int index, {
//   bool? isOn,
//   List<LatLng>? points,
//   String? name,
//   String? initialTime,
//   String? stopTime,
// }) async {
//   List<ZoneData> zones = await loadZones();
//   int idx = zones.indexWhere((z) => z.index == index);

//   if (idx != -1) {
//     if (isOn != null) zones[idx].isOn = isOn;
//     if (points != null) zones[idx].points = points;
//     if (name != null) zones[idx].name = name;
//     if (initialTime != null) zones[idx].initialTime = initialTime;
//     if (stopTime != null) zones[idx].stopTime = stopTime;
//   }

//   await saveZones(zones);
// }

// // -------------------- DELETE --------------------
// Future<void> deleteZone(int index) async {
//   List<ZoneData> zones = await loadZones();

//   zones.removeWhere((z) => z.index == index);

//   // reassign indices
//   for (int i = 0; i < zones.length; i++) {
//     zones[i].index = i;
//   }

//   await saveZones(zones);
// }
