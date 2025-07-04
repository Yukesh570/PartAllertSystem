import 'package:Parkalert/utils/constants/image_strings.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/constants/text_strings.dart';
import 'package:Parkalert/utils/healper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class loginheader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          width: 150,
          image: AssetImage(dark ? TImages.lightAppLogo : TImages.darkAppLogo),
        ),
        Text(
          TTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: TSizes.sm),
        Text(
          TTexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
