import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/ad_presentation_state.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';

class InterstitialAdManager {
  InterstitialAdManager._();

  static final InterstitialAdManager instance = InterstitialAdManager._();

  final Map<String, InterstitialAd> _ads = {};
  final Map<String, bool> _isLoading = {};
  final Map<String, bool> _isShowing = {};

  bool isReady(String placementKey) => _ads.containsKey(placementKey);

  Future<void> preload(
    String placementKey,
    Future<String> adUnitIdFuture,
  ) async {
    if (_isLoading[placementKey] == true) {
      debugPrint(
        'InterstitialAdManager.preload[$placementKey]: already loading, skip.',
      );
      return;
    }
    if (_ads.containsKey(placementKey)) {
      debugPrint(
        'InterstitialAdManager.preload[$placementKey]: already cached, skip.',
      );
      return;
    }

    if (!AdRemoteConfigService.instance.isEnabled(placementKey)) {
      debugPrint(
        'InterstitialAdManager.preload[$placementKey]: placement OFF in Remote Config, skip.',
      );
      return;
    }

    final canRequest = await AdConsentService.instance.canRequestAds();
    if (!canRequest) {
      debugPrint(
        'InterstitialAdManager.preload[$placementKey]: consent not resolved/denied, skip.',
      );
      return;
    }

    _isLoading[placementKey] = true;
    final adUnitId = await adUnitIdFuture;
    debugPrint(
      'InterstitialAdManager.preload[$placementKey]: requesting, adUnitId=$adUnitId',
    );

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('InterstitialAdManager.preload[$placementKey]: loaded.');
          _ads[placementKey] = ad;
          _isLoading[placementKey] = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint(
            'InterstitialAdManager.preload[$placementKey]: FAILED to load. $error',
          );
          _isLoading[placementKey] = false;
        },
      ),
    );
  }

  void showThenProceed(
    String placementKey, {
    required Future<String> Function() adUnitIdFuture,
    required VoidCallback onProceed,
    bool reloadAfterShow = true,
  }) {
    final ad = _ads[placementKey];

    if (ad == null || _isShowing[placementKey] == true) {
      onProceed();
      if (reloadAfterShow) preload(placementKey, adUnitIdFuture());
      return;
    }

    if (AdPresentationState.instance.isPresenting) {
      debugPrint(
        'InterstitialAdManager.showThenProceed[$placementKey]: another ad is presenting, skipping show.',
      );
      onProceed();
      return;
    }

    AdPresentationState.instance.markPresenting();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowing[placementKey] = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowing[placementKey] = false;
        AdPresentationState.instance.markIdle();
        ad.dispose();
        _ads.remove(placementKey);
        onProceed();
        if (reloadAfterShow) preload(placementKey, adUnitIdFuture());
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowing[placementKey] = false;
        AdPresentationState.instance.markIdle();
        ad.dispose();
        _ads.remove(placementKey);
        onProceed();
        if (reloadAfterShow) preload(placementKey, adUnitIdFuture());
      },
    );

    ad.show();
  }

  void disposeAll() {
    for (final ad in _ads.values) {
      ad.dispose();
    }
    _ads.clear();
    _isLoading.clear();
    _isShowing.clear();
  }
}
