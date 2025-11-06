import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Parkalert/utils/healper/permissiongate.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _box = GetStorage();
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();

    // read registration flag
    _isRegistered = _box.read('isRegistered') ?? false;

    // wait 2-3 seconds before navigating
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => PermissionGate(
            isRegistered: _isRegistered,
            onLocaleChange: (locale) {},
          ),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logos/parkalramsplash.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
