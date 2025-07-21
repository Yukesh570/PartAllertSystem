import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:android_intent_plus/android_intent.dart';

Future<void> openBluetoothSettings(BuildContext context) async {
  const intent = AndroidIntent(action: 'android.settings.BLUETOOTH_SETTINGS');

  try {
    await intent.launch();
  } catch (e) {
    debugPrint('Failed to open Bluetooth settings: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open Bluetooth settings')),
    );
  }
}

Future<void> showPairedDevicesPicker({
  required BuildContext context,
  required TextEditingController controller,
}) async {
  bool isEnabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;
  if (!isEnabled) {
    await FlutterBluetoothSerial.instance.requestEnable();
    isEnabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;
    if (!isEnabled) {
      return;
    }
  }

  List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance
      .getBondedDevices();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Paired Device'),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    List<BluetoothDevice> updatedDevices =
                        await FlutterBluetoothSerial.instance
                            .getBondedDevices();
                    setState(() {
                      devices = updatedDevices;
                    });
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = devices[index];
                  return ListTile(
                    title: Text(device.name ?? "Unknown Device"),
                    subtitle: Text(device.address),
                    onTap: () {
                      Navigator.of(context).pop(device);
                    },
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: AppColors.iconColor),
                onPressed: () {
                  openBluetoothSettings(context);
                },
              ),
            ],
          );
        },
      );
    },
  ).then((selectedDevice) {
    if (selectedDevice != null) {
      print(
        "Selected device: ${selectedDevice.name} (${selectedDevice.address})",
      );
      controller.text = selectedDevice.name ?? "Unknown Device";
    }
  });
}
