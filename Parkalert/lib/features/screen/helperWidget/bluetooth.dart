// import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
// import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:android_intent_plus/android_intent.dart';

// Future<void> openBluetoothSettings(BuildContext context) async {
//   const intent = AndroidIntent(action: 'android.settings.BLUETOOTH_SETTINGS');

//   try {
//     await intent.launch();
//   } catch (e) {
//     debugPrint('Failed to open Bluetooth settings: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Could not open Bluetooth settings')),
//     );
//   }
// }

// Future<void> showPairedDevicesPicker({
//   required BuildContext context,
//   required TextEditingController controller,
// }) async {
//   bool isEnabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;
//   if (!isEnabled) {
//     await FlutterBluetoothSerial.instance.requestEnable();
//     isEnabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;
//     if (!isEnabled) {
//       return;
//     }
//   }

//   List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance
//       .getBondedDevices();

//   showDialog(
//     context:
//         context, //context (short for BuildContext) is a reference to the location of a widget
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Select Paired Device'),
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: () async {
//                     List<BluetoothDevice> updatedDevices =
//                         await FlutterBluetoothSerial.instance
//                             .getBondedDevices();
//                     setState(() {
//                       devices = updatedDevices;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             content: SizedBox(
//               width: double.maxFinite,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: devices.length,
//                 itemBuilder: (context, index) {
//                   BluetoothDevice device = devices[index];
//                   return ListTile(
//                     title: Text(device.name ?? "Unknown Device"),
//                     subtitle: Text(device.address),
//                     onTap: () {
//                       Navigator.of(context).pop(device);
//                     },
//                   );
//                 },
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.add, color: AppColors.iconColor),
//                 onPressed: () {
//                   openBluetoothSettings(context);
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     },
//   ).then((selectedDevice) {
//     if (selectedDevice != null) {
//       print(
//         "Selected device: ${selectedDevice.name} (${selectedDevice.address})",
//       );
//       controller.text = selectedDevice.name ?? "Unknown Device";
//     }
//   });
// }
import 'dart:io' show Platform;

import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

class PairedDevicesDialog extends StatefulWidget {
  @override
  _PairedDevicesDialogState createState() => _PairedDevicesDialogState();
}

class _PairedDevicesDialogState extends State<PairedDevicesDialog> {
  final FlutterBlueClassic bluetooth = FlutterBlueClassic(
    usesFineLocation: true,
  );
  List<BluetoothDevice> bondedDevices = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBondedDevices();
  }

  Future<void> loadBondedDevices() async {
    setState(() {
      loading = true;
    });

    bluetooth.turnOn(); // Note: void method, just call

    final bool enabled = await bluetooth.isEnabled;
    if (!enabled) {
      // You may want to prompt user to enable Bluetooth here
      setState(() {
        bondedDevices = [];
        loading = false;
      });
      return;
    }

    final devices = await bluetooth.bondedDevices;
    print("Loaded bonded devices count: ${devices?.length}");
    devices?.forEach((d) {
      print("Device: ${d.name} - ${d.address}");
    });
    setState(() {
      bondedDevices = devices ?? [];
      loading = false;
    });
  }

  Future<void> openBluetoothSettings(BuildContext context) async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.BLUETOOTH_SETTINGS',
      );
      try {
        await intent.launch();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open Bluetooth settings: $e')),
        );
      }
    } else if (Platform.isIOS) {
      // iOS does NOT allow direct Bluetooth settings opening,
      // open general app settings as fallback:
      final url = Uri.parse(
        'App-Prefs:Bluetooth',
      ); // This scheme may not work on all iOS versions
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open Bluetooth settings')),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unsupported platform')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: dark
          ? AppColors.alert3Dark
          : Colors.white, // 👈 Dark/Light mode
      insetPadding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Select Paired Device"),
            actions: [
              IconButton(
                icon: Icon(Icons.settings_bluetooth),
                tooltip: "Open Bluetooth Settings",
                onPressed: () => openBluetoothSettings(context),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                tooltip: "Refresh Paired Devices",
                onPressed: loadBondedDevices,
              ),
            ],
          ),
          if (loading)
            Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            )
          else if (bondedDevices.isEmpty)
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("No paired devices found."),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bondedDevices.length,
                itemBuilder: (_, index) {
                  final device = bondedDevices[index];

                  return ListTile(
                    title: Text(device.name ?? "Unknown"),
                    subtitle: Text(device.address ?? "No address"),
                    onTap: () => Navigator.pop(context, device),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
