import 'dart:convert';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

//saves the Zones
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
    print("zone index: ${newZone.index}");
    print("zone index: ${newZone.name}");

    print("zone index: ${newZone.initialTime}");

    print("zone index: ${newZone.stopTime}");
    print("zone index: ${newZone.isOn}");

    if (!allZones.any((r) => r.index == newZone.index)) {
      allZones.add(newZone);
    }
  }

  // Save merged list back
  List<String> mergeJsonList = allZones
      .map((r) => jsonEncode(r.toJson()))
      .toList();
  return await prefs.setStringList('zones', mergeJsonList);
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
) async {
  print("6969696969669696969696969696969696${name}");
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingJsonList = prefs.getStringList('zones');

  List<ZoneData> allZones = existingJsonList!
      .map((jsonStr) => ZoneData.fromJson(jsonDecode(jsonStr)))
      .toList();

  int indexToUpdate = allZones.indexWhere((r) => r.index == index);

  if (indexToUpdate != -1) {
    if (points == null && name == null) {
      print(
        "auuuuuuueeeeeee1231231231231231231===================================rr${name}",
      );
      allZones[indexToUpdate].isOn = isOn!;
    } else if (isOn == null && name == null) {
      print(
        "auuuuuuueeeeeee1231231231231231231===================================rr${name}",
      );
      allZones[indexToUpdate].points = points!;
    } else {
      print(
        "================auuuuuuueeeeeee1231231231231231231===================================rr${name}",
      );

      allZones[indexToUpdate].name = name!;
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
