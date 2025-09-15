import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/information/information.dart';

class PermissionGate extends StatefulWidget {
  final bool isRegistered;
  final Function(Locale) onLocaleChange;

  const PermissionGate({
    Key? key,
    required this.isRegistered,
    required this.onLocaleChange,
  }) : super(key: key);

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate>
    with WidgetsBindingObserver {
  bool _ready = false;
  bool _checkingPermissions = false; // prevent multiple dialogs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Show permission check after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Delay slightly to avoid black flash
      Future.delayed(const Duration(milliseconds: 200), () {
        _checkAndRequestPermissions();
      });
    }
  }

  Future<void> _checkAndRequestPermissions() async {
    if (_checkingPermissions) return; // prevent duplicate calls
    _checkingPermissions = true;

    // Step 0: Check if already granted
    if (await Permission.location.isGranted &&
        await Permission.locationAlways.isGranted) {
      if (mounted && !_ready) setState(() => _ready = true);
      _checkingPermissions = false;
      return;
    }

    // Small delay to avoid black flash
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) {
      _checkingPermissions = false;
      return;
    }

    // Step 1: Show permission explanation dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Location Permission Needed"),
        content: const Text(
          "This app requires location access to detect Bluetooth events "
          "and geofences. Please allow access to continue.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _checkingPermissions = false;
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _requestLocationPermissions();
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  Future<void> _requestLocationPermissions() async {
    // Step 2: Request foreground location
    var locStatus = await Permission.location.request();
    if (!locStatus.isGranted) {
      debugPrint("❌ Foreground location denied");
      _checkingPermissions = false;
      return;
    }

    // Step 3: Request background location
    var bgStatus = await Permission.locationAlways.request();
    if (!bgStatus.isGranted) {
      debugPrint("⚠️ Background location denied");

      if (!mounted) {
        _checkingPermissions = false;
        return;
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text("Allow 'All the time' Location"),
          content: const Text(
            "To detect Bluetooth events and geofences even when the app is closed, "
            "please enable 'Allow all the time' in Settings.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _checkingPermissions = false;
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings();
                _checkingPermissions = false;
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
      return;
    }

    // ✅ All permissions granted → unlock home
    if (mounted) setState(() => _ready = true);
    _checkingPermissions = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return widget.isRegistered
        ? const Alert()
        : Information(onLocaleChange: widget.onLocaleChange);
  }
}
