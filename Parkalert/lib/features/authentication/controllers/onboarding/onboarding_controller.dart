import 'package:Parkalert/features/authentication/screen/information/information.dart';
import 'package:Parkalert/features/authentication/screen/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  //variable
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs; //obs is a observable variable in GetX

  void updatePageIndicator(int index) => currentPageIndex.value = index;

  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void nextPage() {
    if (currentPageIndex.value == 2) {
      Get.offAll(Information());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void skipPage() {
    currentPageIndex.value = 2;
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
