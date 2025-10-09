import 'package:Parkalert/app.dart';
import 'package:Parkalert/common/widgets/login_signUp/form_divider.dart';
import 'package:Parkalert/common/widgets/login_signUp/socialButton.dart';
import 'package:Parkalert/features/screen/information/widget/agreePolicy.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:Parkalert/l10n/app_localizations.dart';

class InformationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  const InformationForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: firstNameController,
            decoration: InputDecoration(
              labelText: loc.firstName,
              prefixIcon: Icon(Iconsax.user),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.firstName} ${loc.isrequired}';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: lastNameController,
            decoration: InputDecoration(
              labelText: loc.lastName,
              prefixIcon: Icon(Iconsax.user),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.lastName} ${loc.isrequired}';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: loc.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.email} ${loc.isrequired}';
              }
              // Optional: simple email format check
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return loc.enteravalidemail;
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: loc.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${loc.phoneNo} ${loc.isrequired}';
              }
              // Optional: simple phone number check
              if (!RegExp(r'^\+?\d{7,15}$').hasMatch(value)) {
                return loc.enteravalidphonenumber;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
