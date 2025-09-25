import 'package:flutter/services.dart';

class GeofenceBtService {
  static const MethodChannel _platform = MethodChannel(
    'com.parkalert/geofence_bt',
  );

  static Future<void> requestGeofencePermissions() async {
    await _platform.invokeMethod('requestGeofencePermissions');
  }

  static Future<void> updateZones(List<Map<String, dynamic>> zonesJson) async {
    await _platform.invokeMethod('updateZones', zonesJson);
  }

  static Future<void> setBluetoothTarget(String name) async {
    await _platform.invokeMethod('setBluetoothTarget', {'name': name});
  }

  static void initListener() {
    _platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'enteredZone':
          print('Entered zone: ${call.arguments}');
          break;
        case 'exitedZone':
          print('Exited zone: ${call.arguments}');
          break;
        case 'bluetoothConnected':
          print('BT connected: ${call.arguments}');
          break;
        case 'bluetoothDisconnected':
          print('BT disconnected: ${call.arguments}');
          break;
      }
    });
  }
}
