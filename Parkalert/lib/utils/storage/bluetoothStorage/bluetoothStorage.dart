import 'dart:convert';
import 'dart:ffi';

import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/utils/storage/ringerStorage/ringerStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<RingerData> activeBluetooth() async {
  final List<RingerData> savedRingers = await loadRingers();

  for (var ringer in savedRingers) {
    print("Index: ${ringer.index}");
    print("Date: ${ringer.date}");
    print("Time: ${ringer.time}");
    print("Is On: ${ringer.isOn}");
    print("Name: ${ringer.name}");
    print("Bluetooth: ${ringer.bluetooth}");
    print("Sound: ${ringer.sound}");
    print("----------");
  }

  final RingerData activeRinger = savedRingers.firstWhere(
    (ringer) => ringer.isOn,
    orElse: () => RingerData(
      index: 0,
      date: '',
      time: '',
      isOn: false,
      name: '',
      bluetooth: '',
      sound: '',
    ),
  );
  Map<String, String> data = {
    'bluetooth': activeRinger.bluetooth,
    'sound': activeRinger.sound,
    'name': activeRinger.name,
  };
  print("YUUUUUKKKKKESHHHHH${data}");

  final prefs = await SharedPreferences.getInstance();
  // print("activeBluetoothasasasa: +++++++========${activeRinger.bluetooth}");
  if (activeRinger.bluetooth.trim().isNotEmpty) {
    await prefs.setString('activeBluetooth', jsonEncode(data));
  } else {
    await prefs.remove('activeBluetooth');
  }
  return activeRinger;
}

Future<Map<String, String>> loadActiveBluetooth() async {
  final prefs = await SharedPreferences.getInstance();
  print('swetttttttttttttaaaaaaaaaaaaa');

  final String? jsonString = prefs.getString('activeBluetooth');
  print('swetttttttttttttaaaaaaaaaaaaa');

  if (jsonString == null) return {'bluetooth': '', 'sound': '', 'name': ''};
  print('swetttttttttttttaaaaaaaaaaaaa');

  final Map<String, dynamic> data = jsonDecode(jsonString);
  print('swetttttttttttttaaaaaaaaaaaaa');

  return {
    'bluetooth': data['bluetooth']?.toString() ?? '',
    'sound': data['sound']?.toString() ?? '',
    'name': data['name']?.toString() ?? '',
  };
}
