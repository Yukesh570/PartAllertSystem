import 'package:Parkalert/common/styles/spacing_styles.dart';
import 'package:Parkalert/common/widgets/login_signUp/form_divider.dart';
import 'package:Parkalert/common/widgets/login_signUp/socialButton.dart';
import 'package:Parkalert/features/authentication/screen/login/widgets/login_form.dart';
import 'package:Parkalert/features/authentication/screen/login/widgets/login_header.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:Parkalert/utils/constants/image_strings.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/constants/text_strings.dart';
import 'package:Parkalert/utils/healper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              loginheader(),
              loginForm(),
              formDivider(),
              sizedBox(),
              SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
