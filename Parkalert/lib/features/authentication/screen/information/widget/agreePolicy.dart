import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:Parkalert/common/widgets/login_signUp/form_divider.dart';
import 'package:Parkalert/common/widgets/login_signUp/socialButton.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AgreePolicyTextChoice extends StatelessWidget {
  const AgreePolicyTextChoice({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(value: false, onChanged: (value) {}),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                (TextSpan(
                  children: [
                    TextSpan(
                      text: '${loc.iAgreeTo} ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: '${loc.privacyPolicy} ',
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: dark ? Colors.white : TColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: '${loc.and} ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: loc.termsOfUse,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ? Colors.white : TColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: dark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
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
            const SizedBox(width: 10),

            Expanded(
              child: Text(
                loc.inform,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
