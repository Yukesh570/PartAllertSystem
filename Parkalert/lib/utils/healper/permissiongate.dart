import 'dart:io';

import 'package:Parkalert/l10n/app_localizations.dart';
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
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final loc = AppLocalizations.of(ctx); // ✅ add this line
        if (loc == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text(
            loc.locationpermission,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          content: Text(
            loc.locationpermissionparagraph,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(ctx);
            //     _checkingPermissions = false;
            //   },
            //   child: Text(
            //     loc.cancel,
            //     style: TextStyle(
            //       color: isDark ? Colors.white : Colors.black,

            //       fontSize: 18, // 👈 Bigger text
            //       fontWeight: FontWeight.w600, // 👈 Semi-bold
            //     ),
            //   ),
            // ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _requestLocationPermissions();
              },
              child: Text(
                loc.okay,
                style: TextStyle(
                  color: isDark ? Colors.blue[300] : Colors.blue,

                  fontSize: 18, // 👈 Bigger text
                  fontWeight: FontWeight.w600, // 👈 Semi-bold
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestLocationPermissions() async {
    // Step 2: Request foreground location
    var locStatus = await Permission.location.request();
    if (!locStatus.isGranted) {
      debugPrint("Foreground location denied");
      _checkingPermissions = false;
      return;
    }

    // Step 3: Request background location
    var bgStatus = await Permission.locationAlways.request();
    if (!bgStatus.isGranted) {
      debugPrint("Background location denied");

      if (!mounted) {
        _checkingPermissions = false;
        return;
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          final loc = AppLocalizations.of(ctx); // ✅ add this line
          if (loc == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,

            title: Text(
              loc.allowlocation,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            content: Text(
              loc.allowlocationparagraph,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            actions: [
              // TextButton(
              //   onPressed: () {
              //     Navigator.pop(ctx);
              //     _checkingPermissions = false;
              //   },
              //   child: Text(
              //     loc.cancel,
              //     style: TextStyle(color: isDark ? Colors.white : Colors.black),
              //   ),
              // ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  openAppSettings();
                  _checkingPermissions = false;
                },
                child: Text(
                  loc.opensettings,
                  style: TextStyle(
                    color: isDark ? Colors.blue[300] : Colors.blue,

                    fontSize: 18, // 👈 Bigger text
                    fontWeight: FontWeight.w600, // 👈 Semi-bold
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    // ✅ All permissions granted → unlock home
    if (mounted) setState(() => _ready = true);
    _checkingPermissions = false;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        // 🖼 Background Splash Image
        Image.asset(
          'assets/logos/parkalramsplash.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        // ⚪ Foreground content (either loader or next screen)
        if (!_ready)
          const Center(child: CircularProgressIndicator())
        else
          Scaffold(
            body: widget.isRegistered
                ? const Alert()
                : Information(onLocaleChange: widget.onLocaleChange),
          ),
      ],
    );
  }
}

Future<void> requestDoNotDisturbPermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.accessNotificationPolicy.status;
    if (!status.isGranted) {
      await Permission.accessNotificationPolicy.request();
    }
  }
}
