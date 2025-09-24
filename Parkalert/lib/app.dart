import 'package:Parkalert/features/screen/information/information.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/onboarding/onboarding.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/utils/healper/permission.dart';
import 'package:Parkalert/utils/healper/permissiongate.dart';
import 'package:flutter/material.dart';
import 'package:Parkalert/utils/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _box = GetStorage();
  bool _isRegistered = false; // new flag

  Locale _locale = const Locale('en'); // Default locale

  @override //“Hey, I’m overriding a method from the parent class.”
  void initState() {
    // initState Runs only once, when the widget is first created.
    super.initState();
    final savedLangCode = _box.read('languagecode');
    if (savedLangCode != null) {
      _locale = Locale(savedLangCode);
    }
    // ✅ Check if user already created an account
    _isRegistered = _box.read('isRegistered') ?? false;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   requestLocationPermissions(context);
    // });
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _box.write('languagecode', locale.languageCode); //save locale
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print("selectedLansdsdsdg: $_locale");

    return GetMaterialApp(
      locale: Locale(GetStorage().read("languagecode") ?? "en"),
      fallbackLocale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,

      localizationsDelegates: const [
        AppLocalizations.delegate, // Generated delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Optional: set the default locale (English here)
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: TAppTheme.darkTheme,
      theme: TAppTheme.lightTheme,
      // builder: (context, child) {
      //   return Localizations.override(
      //     context: context,
      //     locale: _locale,
      //     child: child!,
      //   );
      // },
      home: PermissionGate(
        isRegistered: _isRegistered,
        onLocaleChange: (locale) {
          Get.updateLocale(locale); // ← will update the app instantly
        },
      ),

      // home: _isRegistered
      //     ? const Alert()
      //     : Information(onLocaleChange: _setLocale),
    );
  }
}
