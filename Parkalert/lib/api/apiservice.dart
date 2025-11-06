import 'dart:convert';

import 'package:Parkalert/api/api.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/data/historyData.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backupHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final ApiService apiService = ApiService();
  bool allSuccess = true;

  final jsonString = prefs.getString('flutter.backupcurrentLocation') ?? "[]";
  final List<dynamic> jsonList = json.decode(jsonString);

  final List<String>? zoneStringList = prefs.getStringList("zones");

  // Decode stored zones
  if (zoneStringList != null) {
    List<ZoneData> zoneList = zoneStringList
        .map((e) => ZoneData.fromJson(json.decode(e)))
        .toList();
    final unsavedZones = zoneList.where((z) => z.isSaved == false).toList();
    for (var zone in unsavedZones) {
      try {
        await apiService.createZone(
          index: zone.index,
          name: zone.name,
          initialTime: zone.initialTime,
          stopTime: zone.stopTime,
          isOn: zone.isOn,
          points: zone.points,
        );
        zone.isSaved = true;
      } catch (e) {
        allSuccess = false; // mark failure
      }
    }
    List<String> updatedJsonList = zoneList
        .map((zone) => jsonEncode(zone.toJson()))
        .toList();

    await prefs.setStringList("zones", updatedJsonList);
    // print("Updated Zones in SharedPreferences:");
    // for (var jsonStr in updatedJsonList) {
    //   final zone = ZoneData.fromJson(jsonDecode(jsonStr));
    //   print(
    //     "index: ${zone.index}, name: ${zone.name}, isOn: ${zone.isOn}, isSaved: ${zone.isSaved}, "
    //     "initialTime: ${zone.initialTime}, stopTime: ${zone.stopTime}, points: ${zone.points.length}",
    //   );
    // }
    await Future.delayed(const Duration(seconds: 2));
    // print("backupHistory finished & flushed properly (WorkManager safe)");
  }

  // final zoneList = jsonZoneList.asMap().entries.map((entry) {
  //   final index = entry.key;
  //   final item = entry.value as Map<String, dynamic>;

  //   return ZoneData.fromJson({
  //     "index": index,
  //     "initialTime": item["initialTime"],
  //     "stopTime": item["stopTime"],
  //     "isOn": item["isOn"],
  //     "name": item["name"],
  //     "points": item["points"],
  //   });
  // }).toList();

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

  for (var history in historyList) {
    try {
      await apiService.createHistory(
        index: history.index,
        lat: history.lat,
        lng: history.lng,
        time: history.time,
        name: history.name,
      );
      // print("Sent history index: ${history.index}");
    } catch (e) {
      allSuccess = false; // mark failure

      // print("Failed to send history index ${history.index}: $e");
    }
  }
  if (allSuccess && historyList.isNotEmpty) {
    await prefs.remove("backupcurrentLocation");
    // print("Cleared backupcurrentLocation after successful sync");
  }
}
