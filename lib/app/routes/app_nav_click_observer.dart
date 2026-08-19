import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/services/app_click_interstitial_manager.dart';
import 'package:sketch_flow/app/modules/onboarding/views/ad_loading_gate_view.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/data/services/interstitial_ad_manager.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';

const Set<String> _excludedFromClickCount = {
  Routes.splash,
  Routes.onboarding,
  Routes.languageSelect,
  Routes.languageConfirm,
};

class AppNavClickObserver extends GetObserver {
  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPush(route!, previousRoute);
    _handle(route);
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPop(route!, previousRoute);
  }

  void _handle(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name == null) return;
    if (_excludedFromClickCount.contains(name)) return;

    final shouldShow = AppClickInterstitialManager.instance
        .registerClickAndCheckThreshold(routeName: name);
    if (!shouldShow) return;

    WidgetsBinding.instance.addPostFrameCallback((_) => _showClickInterstitial());
  }

  void _showClickInterstitial() {
    final placementKey = AppClickInterstitialManager.placementKey;

    Get.to(
      () => AdLoadingGateView(
        isReady: () => InterstitialAdManager.instance.isReady(placementKey),
        showAd: (onComplete) => InterstitialAdManager.instance.showThenProceed(
          placementKey,
          adUnitIdFuture: () => AdUnitIds.appClickInterstitial,
          onProceed: onComplete,
        ),
        onFinished: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.back();
            AppClickInterstitialManager.instance.resetCount();
          });
        },
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 200),
    );
  }
}
