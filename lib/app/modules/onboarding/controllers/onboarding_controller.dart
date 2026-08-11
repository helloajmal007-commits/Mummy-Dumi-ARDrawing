import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/onboarding_model.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingSlide> slides = const [
    OnboardingSlide(
      title: 'Draw Anything in AR',
      description:
          'Turn your imagination into reality by sketching directly onto the real world using your camera',
      primaryIcon: Icons.view_in_ar_outlined,
      accentIcon: Icons.edit_outlined,
      background: AppColors.accentSoft,
      accentColor: AppColors.amber,
    ),
    OnboardingSlide(
      title: 'Trace With Precision',
      description:
          'Import any photo and trace over it with adjustable opacity guides for perfect line work',
      primaryIcon: Icons.crop_free,
      accentIcon: Icons.edit_outlined,
      background: AppColors.accentSoft,
      accentColor: AppColors.accent,
    ),
    OnboardingSlide(
      title: 'Save & Share Your Art',
      description:
          'Export finished sketches to your gallery and share your creative process with the world',
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
      Get.offAllNamed(Routes.home);
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void skip() => Get.offAllNamed(Routes.home);

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
