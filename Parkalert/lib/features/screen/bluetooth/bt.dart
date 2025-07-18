import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/flag.dart';

class BluetoothScannerScreen extends StatefulWidget {
  const BluetoothScannerScreen({super.key});

  @override
  State<BluetoothScannerScreen> createState() => _BluetoothScannerScreenState();
}

class _BluetoothScannerScreenState extends State<BluetoothScannerScreen> {
  final List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  void _startScan() async {
    setState(() {
      _scanResults.clear();
      _isScanning = true;
    });

    bool granted = await _requestPermissions();
    if (!granted) {
      setState(() {
        _isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bluetooth and Location permissions are required'),
        ),
      );
      return;
    }

    // Start scanning
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    // Listen for scan results
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _scanResults.clear();
        _scanResults.addAll(results);
      });
    });

    // Listen for scanning status
    FlutterBluePlus.isScanning.listen((scanning) {
      if (!scanning) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  Widget _buildDeviceTile(ScanResult result) {
    final device = result.device;
    final name = device.name.isNotEmpty ? device.name : 'Unknown Device';
    final rssi = result.rssi;

    return ListTile(
      title: Text(name),
      subtitle: Text(device.id.id),
      trailing: Text('$rssi dBm'),
    );
  }

  void _openBluetoothSettings() async {
    const url = 'android.settings.BLUETOOTH_SETTINGS';

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

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airbuds BLE Scanner'),
        actions: [
          IconButton(
            icon: _isScanning
                ? const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isScanning ? null : _startScan,
          ),
          IconButton(
            icon: const Icon(Icons.settings_bluetooth),
            onPressed: _openBluetoothSettings,
          ),
        ],
      ),
      body: _scanResults.isEmpty
          ? Center(
              child: _isScanning
                  ? const Text('Scanning...')
                  : const Text('No devices found.'),
            )
          : ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (context, index) {
                return _buildDeviceTile(_scanResults[index]);
              },
            ),
    );
  }
}
