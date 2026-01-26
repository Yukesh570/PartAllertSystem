import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:country_picker/country_picker.dart';
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
  String selectedCountryPrefix = '+31'; // Default NL

  @override
  void initState() {
    super.initState();
    // IMPORTANT: initialize controller so picker is NOT required
    widget.countryCodeController.text = selectedCountryPrefix;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          /// First Name
          TextFormField(
            controller: widget.firstNameController,
            decoration: InputDecoration(
              labelText: loc.firstName,
              prefixIcon: const Icon(Iconsax.user),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? '${loc.firstName} ${loc.isrequired}'
                : null,
          ),

          const SizedBox(height: 16),

          /// Last Name
          TextFormField(
            controller: widget.lastNameController,
            decoration: InputDecoration(
              labelText: loc.lastName,
              prefixIcon: const Icon(Iconsax.user),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? '${loc.lastName} ${loc.isrequired}'
                : null,
          ),

          const SizedBox(height: 16),

          /// Email
          TextFormField(
            controller: widget.emailController,
            decoration: InputDecoration(
              labelText: loc.email,
              prefixIcon: const Icon(Iconsax.direct),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return '${loc.email} ${loc.isrequired}';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                return loc.enteravalidemail;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          /// Phone Number
          TextFormField(
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: loc.phoneNo,
              prefixIcon: const Icon(Iconsax.call),
              prefix: Text(
                '$selectedCountryPrefix ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: dark ? Colors.white : Colors.black,
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
                  );
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.phoneNo} ${loc.isrequired}';
              }

              final digits = value.replaceAll(RegExp(r'\D'), '');

              // Netherlands validation
              if (selectedCountryPrefix == '+31') {
                final cleaned = digits.startsWith('0')
                    ? digits.substring(1)
                    : digits;

                if (cleaned.length != 9) {
                  return 'Enter a valid Dutch mobile number';
                }
              }

              return null;
            },
            onSaved: (value) {
              // Normalize for backend
              final raw = value!.replaceAll(RegExp(r'\D'), '');
              final cleaned = raw.startsWith('0') ? raw.substring(1) : raw;

              widget.phoneController.text =
                  '${widget.countryCodeController.text}$cleaned';
            },
          ),
        ],
      ),
    );
  }
}
