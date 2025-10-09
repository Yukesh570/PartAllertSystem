import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/screen/information/information.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Changelanguage extends StatefulWidget {
  const Changelanguage({super.key});

  @override
  State<Changelanguage> createState() => _ChangelanguageState();
}

class _ChangelanguageState extends State<Changelanguage> {
  Map<String, dynamic> userData = {};
  final drawerCtrl = Get.find<DrawerControllerX>();
  final MainController controller = Get.put(MainController());
  final List<Map<String, String>> languages = const [
    {'name': 'English (US)', 'code': 'en', 'flag': '🇺🇸'},
    {'name': 'French', 'code': 'fr', 'flag': '🇫🇷'},
    {'name': 'Spanish', 'code': 'es', 'flag': '🇪🇸'},
    {'name': 'Dutch', 'code': 'nl', 'flag': '🇳🇱'},
  ];
  late String selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    print("asdfasdfasdfasdfasdfasd====${GetStorage().read("languagecode")}");

    selectedLanguageCode = GetStorage().read("languagecode") ?? "en";
  }

  void _onLanguageSelected(String code) {
    selectedLanguageCode = code;
    GetStorage().write("languagecode", code);
    Get.updateLocale(Locale(code)); // ← instantly updates entire app
    controller.alertPage();

    setState(() {}); // update local chip selection
  }

  Widget _buildLanguageItem(
    BuildContext context,
    String name,
    String code,
    String flag,
  ) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final isSelected = selectedLanguageCode == code;
    return GestureDetector(
      onTap: () async => await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: dark ? Colors.grey[900] : Colors.white,
          title: Text(loc.changelanguage),
          content: const Text('Are you sure you want to change language?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                loc.cancel,
                style: const TextStyle(
                  fontSize: 18, // 👈 Bigger text
                  fontWeight: FontWeight.w600, // 👈 Semi-bold
                ),
              ),
            ),
            TextButton(
              onPressed: () => _onLanguageSelected(code),
              child: Text(
                loc.yes,
                style: const TextStyle(
                  fontSize: 20, // 👈 Bigger text
                  fontWeight: FontWeight.w600, // 👈 Semi-bold
                ),
              ),
            ),
          ],
        ),
      ),

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: dark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Highlight the selected item with a gold border.
          border: isSelected
              ? Border.all(color: Color.fromARGB(255, 90, 102, 224), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Use a Text widget with emoji for the flag icon.
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Color.fromARGB(255, 90, 102, 224)
                      : (dark ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Show a checkmark for the selected item.
            if (isSelected)
              const Icon(
                Icons.check,
                color: Color.fromARGB(255, 90, 102, 224),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) return const Center(child: CircularProgressIndicator());

    return PageWrapper(
      routeName: '/changelanguage',
      child: Scaffold(
        backgroundColor: dark ? Colors.black : Colors.white,
        drawerEnableOpenDragGesture: false,

        appBar: AppBar(
          backgroundColor: Colors.transparent,

          elevation: 0,
          centerTitle: true,
          title: Text(
            loc.changelanguage,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
            ),
          ),
        ),
        drawer: const navButton(),
        body: SafeArea(
          minimum: const EdgeInsets.only(bottom: 12.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
              ),

              // Background gradient to match the design.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Container(
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color.fromARGB(255, 34, 34, 34)
                        : const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Custom `AppBar` to match the design's rounded bottom.
                      const SizedBox(height: 24),
                      // Use `Expanded` and `SingleChildScrollView` for the scrollable list of languages.
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: languages.map((lang) {
                              return _buildLanguageItem(
                                context,
                                lang['name']!,
                                lang['code']!,
                                lang['flag']!,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCircularIconButton(
                        context: context,
                        icon: Icons.arrow_back,
                        onPressed: () {
                          drawerCtrl.goBack();
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            debugPrint("No screen to go back to");
                          }
                        },
                      ),
                      buildMainButton(
                        text: loc.main,
                        onPressed: () => controller.alertPage(),
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
