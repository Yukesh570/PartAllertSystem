import 'dart:convert';

import 'package:Parkalert/api/api.dart';
import 'package:Parkalert/utils/storage/data/historyData.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backupHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString("backupcurrentLocation") ?? "[]";
  final ApiService apiService = ApiService();

  final List<dynamic> jsonList = json.decode(jsonString);
  bool allSuccess = true;

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
      print("✅ Sent history index: ${history.index}");
    } catch (e) {
      allSuccess = false; // mark failure

      print("❌ Failed to send history index ${history.index}: $e");
    }
  }
  if (allSuccess && historyList.isNotEmpty) {
    await prefs.remove("backupcurrentLocation");
    print("🗑️ Cleared backupcurrentLocation after successful sync");
  }
}
