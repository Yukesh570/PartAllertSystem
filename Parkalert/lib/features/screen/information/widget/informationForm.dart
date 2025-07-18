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
  const InformationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return Form(
      child: Column(
        children: [
          TextFormField(
            expands: false,
            decoration: InputDecoration(
              labelText: loc.firstName,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            expands: false,
            decoration: InputDecoration(
              labelText: loc.lastName,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            expands: false,
            decoration: InputDecoration(
              labelText: loc.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            expands: false,
            decoration: InputDecoration(
              labelText: loc.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
