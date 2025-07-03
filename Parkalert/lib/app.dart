import 'package:Parkalert/features/authentication/screen/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:Parkalert/utils/theme/theme.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: TAppTheme.darkTheme,
      theme: TAppTheme.lightTheme,
      home: const OnBoardingScreen(),
    );
  }
}
