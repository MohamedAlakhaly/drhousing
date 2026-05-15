import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/models/data/on_boarding_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class OnBoardingController extends GetxController {
  void goToSignUp();
  void addPercent();
  void jumpToNextSlide();
}

class OnBoardingControllerImp extends OnBoardingController {
  late PageController pageController;
  int currentPage = 0;
  double currentPercent = 0.25;

  //! addPercent function this function used to add percent to circle progress
  @override
  addPercent() {
    if (currentPage == 0) {
      currentPercent = 0.25;
      update();
      return;
    }
    if (currentPage == 1) {
      currentPercent = 0.50;
      update();
      return;
    }
    if (currentPage == 2) {
      currentPercent = 0.75;
      update();
      return;
    }
    if (currentPage == 3) {
      currentPercent = 1;
      update();
      return;
    }
    
  }

  //! jumpToNextSlide function this function used to jump to next slide
  @override
  jumpToNextSlide() {
    currentPage == onBoardingData.length-1
        ? Get.offAllNamed(AppRoutes.chooseAuthMethod)
        : pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
  }

  void skipButton() {
    pageController.jumpToPage(onBoardingData.length-1);
    currentPercent = 1;
    currentPage = onBoardingData.length-1;
    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //! goToSignUp function this function used to go to sign up page
  @override
  goToSignUp() {
    Get.offAllNamed(AppRoutes.signUp);
  }
}
