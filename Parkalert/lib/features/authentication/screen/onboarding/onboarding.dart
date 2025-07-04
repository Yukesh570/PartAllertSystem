import 'package:Parkalert/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:Parkalert/features/authentication/screen/onboarding/widgets/onboarding_page.dart';
import 'package:Parkalert/features/authentication/screen/onboarding/widgets/onboarding_skip.dart';
import 'package:Parkalert/features/authentication/screen/onboarding/widgets/onboaring_dot_navigation.dart';
import 'package:Parkalert/utils/constants/colors.dart';
import 'package:Parkalert/utils/constants/image_strings.dart';
import 'package:Parkalert/utils/constants/sizes.dart';
import 'package:Parkalert/utils/constants/text_strings.dart';
import 'package:Parkalert/utils/device/device_utility.dart';
import 'package:Parkalert/utils/healper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,

            children: const [
              OnBoardingPage(
                image: TImages.onBoardingImage1,
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              ),

              // You can add more onboarding pages here
            ],
          ),
          const onBoardingSkip(),
          const onBoardingDotNavigation(),
          OnBoardingNextButton(),
        ],
      ),
    );
  }
}

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () {
          print("OnBoardingNextButton pressed!");
          OnBoardingController.instance.nextPage();
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: dark ? TColors.primary : TColors.dark,
        ),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
