import 'package:Parkalert/common/widgets/login_signUp/form_divider.dart';
import 'package:Parkalert/common/widgets/login_signUp/socialButton.dart';
import 'package:Parkalert/features/controllers/information/information_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/screen/helperWidget/sound.dart';
import 'package:Parkalert/features/screen/information/widget/agreePolicy.dart';
import 'package:Parkalert/features/screen/information/widget/informationForm.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/constants/text_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Information extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const Information({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  String? selectedLang; // No language selected initially

  void changeLanguage(String langCode) {
    print("Language changed to: $langCode");
    setState(() {
      selectedLang = langCode;
    });
    print("selectedLang: $selectedLang");

    widget.onLocaleChange(Locale(langCode.toLowerCase()));
  }

  @override
  void initState() {
    super.initState();
    NotificationService.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    final InformationController controller = Get.put(
      InformationController(),
    ); // registers controller

    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    final Map<String, String> languages = {
      "EN": "en",
      "FR": "fr",
      "ES": "es",
      "DU": "nl",
    };
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: Text(
          loc.appTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: dark ? Colors.white : Colors.black, // 👈 Set color here
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const navButton(),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.white,
                border: Border.all(color: TColors.black, width: 1.0),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  if (!dark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                ],
              ),
              padding: const EdgeInsets.all(18), // Space inside the box

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.language,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: dark
                          ? const Color.fromARGB(255, 233, 232, 232)
                          : TColors.dark,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: languages.entries.map((entry) {
                        final label = entry.key;
                        final code = entry.value;
                        return _LanguageChip(
                          label: label,
                          dark: dark,
                          isSelected: selectedLang == code,
                          onTap: () => changeLanguage(
                            code,
                          ), // Update the selected language
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  InformationForm(),
                  AgreePolicyTextChoice(dark: dark),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.InfonextPage();
                      },
                      child: Text(
                        loc.createAccount,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  formDivider(),

                  // Text(
                  //   'This is the information screen where you can find details about the app.',
                  //   style: Theme.of(context).textTheme.headlineMedium,
                  // ),
                  // Add more content here as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final dynamic dark;

  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.label,
    required this.dark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? (dark ? Colors.white24 : Colors.blueAccent)
        : (dark ? TColors.dark : TColors.white);
    final textColor = isSelected
        ? Colors.white
        : Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            color: isSelected
                ? (dark ? Colors.white : Colors.blueAccent)
                : (dark ? TColors.white : TColors.dark),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
