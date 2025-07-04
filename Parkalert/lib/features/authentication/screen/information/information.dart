import 'package:Parkalert/common/widgets/login_signUp/form_divider.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  String? selectedLang; // No language selected initially
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Container(
            decoration: BoxDecoration(
              color: dark ? TColors.dark : TColors.white,
              border: Border.all(color: TColors.black, width: 1.0),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(18), // Space inside the box

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TTexts.language,
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
                    children: ["NL", "EN", "ES", "DU", "FR"].map((lang) {
                      return _LanguageChip(
                        label: lang,
                        dark: dark,
                        isSelected: selectedLang == lang,
                        onTap: () {
                          setState(() {
                            selectedLang = lang;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.0),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        expands: false,
                        decoration: InputDecoration(
                          labelText: TTexts.firstName,
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        expands: false,
                        decoration: InputDecoration(
                          labelText: TTexts.lastName,
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        expands: false,
                        decoration: InputDecoration(
                          labelText: TTexts.email,
                          prefixIcon: Icon(Iconsax.direct),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        expands: false,
                        decoration: InputDecoration(
                          labelText: TTexts.phoneNo,
                          prefixIcon: Icon(Iconsax.call),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(value: false, onChanged: (value) {}),
                        ),
                        Expanded(
                          child: Text.rich(
                            (TextSpan(
                              children: [
                                TextSpan(
                                  text: '${TTexts.iAgreeTo} ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: '${TTexts.privacyPolicy} ',
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .apply(
                                        color: dark
                                            ? Colors.white
                                            : Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: dark
                                            ? Colors.white
                                            : TColors.primary,
                                      ),
                                ),
                                TextSpan(
                                  text: '${TTexts.and} ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: TTexts.termsOfUse,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .apply(
                                        color: dark
                                            ? Colors.white
                                            : TColors.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: dark
                                            ? Colors.white
                                            : Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                      ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(value: false, onChanged: (value) {}),
                        ),
                        Expanded(
                          child: Text(
                            TTexts.inform,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Text(
                //   'This is the information screen where you can find details about the app.',
                //   style: Theme.of(context).textTheme.headlineMedium,
                // ),
                // Add more content here as needed
              ],
            ),
          ),
        ),
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
        width: 48,
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
