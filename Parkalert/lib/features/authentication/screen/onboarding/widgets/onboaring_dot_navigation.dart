import 'package:Parkalert/features/authentication/controllers.onboarding/onboarding_controller.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/device/device_utility.dart';
import 'package:Parkalert/utils/healper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoardingDotNavigation extends StatelessWidget {
  const onBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3, // Adjust based on the number of onboarding pages
        effect: ExpandingDotsEffect(
          dotHeight: 10,
          activeDotColor: dark ? TColors.white : TColors.dark,
        ),
      ),
    );
  }
}
