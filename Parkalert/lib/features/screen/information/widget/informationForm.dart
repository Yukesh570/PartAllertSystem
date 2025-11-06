import 'package:Parkalert/app.dart';
import 'package:Parkalert/common/widgets/login_signUp/form_divider.dart';
import 'package:Parkalert/common/widgets/login_signUp/socialButton.dart';
import 'package:Parkalert/features/screen/information/widget/agreePolicy.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/constants/text_strings.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:Parkalert/l10n/app_localizations.dart';

class InformationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController countryCodeController;

  const InformationForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.countryCodeController,
  });

  @override
  State<InformationForm> createState() => _InformationFormState();
}

class _InformationFormState extends State<InformationForm> {
  String selectedCountryPrefix = '+31'; // Default country code
  final List<String> allowedCountryCodes = ['NL', 'FR', 'DE', 'GB'];
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // First Name
          TextFormField(
            controller: widget.firstNameController,
            decoration: InputDecoration(
              labelText: loc.firstName,
              prefixIcon: const Icon(Iconsax.user),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.firstName} ${loc.isrequired}';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Last Name
          TextFormField(
            controller: widget.lastNameController,
            decoration: InputDecoration(
              labelText: loc.lastName,
              prefixIcon: const Icon(Iconsax.user),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.lastName} ${loc.isrequired}';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: widget.emailController,
            decoration: InputDecoration(
              labelText: loc.email,
              prefixIcon: const Icon(Iconsax.direct),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.email} ${loc.isrequired}';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return loc.enteravalidemail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Number with Country Picker
          TextFormField(
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: loc.phoneNo,
              prefixIcon: const Icon(Iconsax.call),
              prefix: Text(
                selectedCountryPrefix + " ",
                style: TextStyle(
                  color: dark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: dark ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountryPrefix = '+${country.phoneCode}';
                        widget.countryCodeController.text =
                            selectedCountryPrefix;
                      });
                    },
                    countryListTheme: CountryListThemeData(
                      backgroundColor: dark ? Colors.grey[900] : Colors.white,
                      textStyle: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(
                          color: dark ? Colors.white70 : Colors.black54,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: dark ? Colors.white24 : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.phoneNo} ${loc.isrequired}';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
