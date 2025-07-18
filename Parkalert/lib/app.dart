import 'package:Parkalert/features/screen/information/information.dart';
import 'package:Parkalert/features/screen/onboarding/onboarding.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:Parkalert/utils/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _box = GetStorage();

  Locale _locale = const Locale('en'); // Default locale

  @override //“Hey, I’m overriding a method from the parent class.”
  void initState() {
    // initState Runs only once, when the widget is first created.
    super.initState();
    final savedLangCode = _box.read('languagecode');
    if (savedLangCode != null) {
      _locale = Locale(savedLangCode);
    }
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
      locale: _locale,
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
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: _locale,
          child: child!,
        );
      },
      home: Information(onLocaleChange: _setLocale),
    );
  }
}
