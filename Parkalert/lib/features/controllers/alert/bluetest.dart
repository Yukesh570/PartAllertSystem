// import 'package:flutter/material.dart';
// import 'package:flutter_blue_classic/flutter_blue_classic.dart';

// class BluetoothConnectPage extends StatefulWidget {
//   @override
//   _BluetoothConnectPageState createState() => _BluetoothConnectPageState();
// }

// class _BluetoothConnectPageState extends State<BluetoothConnectPage> {
//   FlutterBlueClassic flutterBlueClassic = FlutterBlueClassic();
//   BluetoothDevice? targetDevice;
//   BluetoothConnection? connection;

//   final String targetAddress = "43:45:33:F9:CF:76";

//   String status = 'Starting scan...';

//   @override
//   void initState() {
//     super.initState();
//     startScanAndConnect();
//   }

//   void startScanAndConnect() {
//     flutterBlueClassic.startScan();

//     // Optionally stop scan after 10 seconds if device not found
//     Future.delayed(Duration(seconds: 10), () {
//       flutterBlueClassic.stopScan();
//       if (connection == null) {
//         setState(() {
//           status = 'Scan stopped: Device not found';
//         });
//       }
//     });

//     flutterBlueClassic.scanResults.listen((BluetoothDevice device) async {
//       print('Found device: ${device.name} - ${device.address}');

//       if (device.address.toUpperCase() == targetAddress.toUpperCase()) {
//         setState(() => status = 'Device found: ${device.name}, connecting...');
//         flutterBlueClassic.stopScan();

//         try {
//           // Connect using the static method on FlutterBlueClassic
//           connection = await flutterBlueClassic.connect(device.address);
//           setState(() => status = 'Connected to ${device.address}');
//         } catch (e) {
//           setState(() => status = 'Failed to connect: $e');
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     connection?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Auto Bluetooth Connect')),
//       body: Center(child: Text(status)),
//     );
//   }
// }
