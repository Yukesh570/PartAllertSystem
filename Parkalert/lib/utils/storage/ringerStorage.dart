import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Parkalert/data/RingerData.dart';

//saves the ringers
Future<void> saveRingers(List<RingerData> ringers) async {
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
  await prefs.setStringList('ringers', mergeJsonList);
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
