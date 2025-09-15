// import 'dart:convert';
// import 'package:Parkalert/utils/storage/data/historyData.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// List<Historydata> history = [];
// bool _loadingHistory = true;

// Future<List<Historydata>> loadSavedLocations() async {
//   final prefs = await SharedPreferences.getInstance();
//   final jsonString = prefs.getString("flutter.currentLocation") ?? "[]";

//   // Decode the JSON string into a list of maps
//   final List<dynamic> jsonList = json.decode(jsonString);

  
//    final historyList = jsonList.asMap().entries.map((entry) {
//     final index = entry.key;
//     final item = entry.value as Map<String, dynamic>;
//     return Historydata.fromJson({
//       "index": index,
//       "lat": item["lat"],
//       "lng": item["lng"],
//       "time": item["time"].toString(),
//       "name": item["name"],
//     });
//   }).toList();
  
//   setState(() {
//     history = historyList;
//     _loadingHistory = false;
//   });
// }
