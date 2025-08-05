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
  print("YUUUUUKKKKKESHHHHH${activeRinger.isOn}");

  final prefs = await SharedPreferences.getInstance();
  // print("activeBluetoothasasasa: +++++++========${activeRinger.bluetooth}");

  await prefs.setString('activeBluetooth', activeRinger.bluetooth);
  return activeRinger;
}

Future<String> loadActiveBluetooth() async {
  final prefs = await SharedPreferences.getInstance();
  String bluetooth = prefs.getString('activeBluetooth') ?? '';
  return bluetooth;
}
