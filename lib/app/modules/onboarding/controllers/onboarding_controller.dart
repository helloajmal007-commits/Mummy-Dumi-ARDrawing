import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/models/onboarding_model.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/data/services/interstitial_ad_manager.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/onboarding/views/ad_loading_gate_view.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

enum OnboardingPageType { slide, fullNativeAd }

class OnboardingPage {
  final OnboardingPageType type;
  final OnboardingSlide? slide;
  final String? adPlacementKey;
  final Future<String>? adUnitIdOverride;

  const OnboardingPage.slide(this.slide)
    : type = OnboardingPageType.slide,
      adPlacementKey = null,
      adUnitIdOverride = null;

  const OnboardingPage.fullNativeAd(this.adPlacementKey, this.adUnitIdOverride)
    : type = OnboardingPageType.fullNativeAd,
      slide = null;
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final RxSet<int> _adPagesResolved = <int>{}.obs;

  List<OnboardingSlide> get _slides => [
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

  late final List<OnboardingPage> pages = [
    OnboardingPage.slide(_slides[0]),
    OnboardingPage.fullNativeAd(
      AdPlacementKeys.fullNativeOnboardingSlide1to2,
      AdUnitIds.fullNativeOnboardingSlide1to2,
    ),
    OnboardingPage.slide(_slides[1]),
    OnboardingPage.fullNativeAd(
      AdPlacementKeys.fullNativeOnboardingSlide2to3,
      AdUnitIds.fullNativeOnboardingSlide2to3,
    ),
    OnboardingPage.slide(_slides[2]),
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  OnboardingPage get currentPageData => pages[currentPage.value];

  bool get canProceed {
    final page = currentPageData;
    if (page.type == OnboardingPageType.slide) return true;
    return _adPagesResolved.contains(currentPage.value);
  }

  void onPageChanged(int index) => currentPage.value = index;

  void reportAdResolved(int pageIndex) {
    _adPagesResolved.add(pageIndex);
  }

  @override
  void onInit() {
    super.onInit();
    InterstitialAdManager.instance.preload(
      AdPlacementKeys.welcomeScreenInterstitial,
      AdUnitIds.welcomeScreenInterstitial,
    );
  }

  void next() {
    if (!canProceed) return;
    if (isLastPage) {
      _finishOnboarding();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _finishOnboarding() {
    final placementKey = AdPlacementKeys.welcomeScreenInterstitial;

    if (!InterstitialAdManager.instance.isReady(placementKey)) {
      StorageService.setHasCompletedOnboarding(true);
      Get.offAllNamed(Routes.home);
      return;
    }

    Get.to(
      () => AdLoadingGateView(
        isReady: () => InterstitialAdManager.instance.isReady(placementKey),
        showAd: (onComplete) => InterstitialAdManager.instance.showThenProceed(
          placementKey,
          adUnitIdFuture: () => AdUnitIds.welcomeScreenInterstitial,
          onProceed: onComplete,
          reloadAfterShow: false,
        ),
        onFinished: () {
          StorageService.setHasCompletedOnboarding(true);
          Get.offAllNamed(Routes.home);
        },
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 200),
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
