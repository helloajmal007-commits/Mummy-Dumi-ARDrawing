import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/onboarding_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  List<OnboardingSlide> get slides => [
    OnboardingSlide(
      title: TKeys.onboardSlide1Title.tr,
      description: TKeys.onboardSlide1Desc.tr,
      primaryIcon: Icons.view_in_ar_outlined,
      accentIcon: Icons.edit_outlined,
      background: AppColors.accentSoft,
      accentColor: AppColors.amber,
    ),
    OnboardingSlide(
      title: TKeys.onboardSlide2Title.tr,
      description: TKeys.onboardSlide2Desc.tr,
      primaryIcon: Icons.crop_free,
      accentIcon: Icons.edit_outlined,
      background: AppColors.accentSoft,
      accentColor: AppColors.accent,
    ),
    OnboardingSlide(
      title: TKeys.onboardSlide3Title.tr,
      description: TKeys.onboardSlide3Desc.tr,
      primaryIcon: Icons.photo_library_outlined,
      accentIcon: Icons.ios_share,
      background: AppColors.accentSoft,
      accentColor: AppColors.lavender,
    ),
  ];

  bool get isLastPage => currentPage.value == slides.length - 1;

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (isLastPage) {
      StorageService.setHasCompletedOnboarding(true);
      Get.offAllNamed(Routes.home);
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void skip() {
    StorageService.setHasCompletedOnboarding(true);
    Get.offAllNamed(Routes.home);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
