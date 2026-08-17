import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';

class AppOpenAdManager {
  AppOpenAdManager._();

  static final AppOpenAdManager instance = AppOpenAdManager._();

  AppOpenAd? _ad;
  bool _isLoading = false;
  bool _isShowingAd = false;
  DateTime? _loadedAt;

  static const Duration _maxCacheAge = Duration(hours: 4);

  bool get isAdAvailable => _ad != null && !_isAdExpired;

  bool get _isAdExpired {
    if (_loadedAt == null) return true;
    return DateTime.now().difference(_loadedAt!) > _maxCacheAge;
  }

  Future<void> preload() async {
    if (_isLoading || isAdAvailable) return;

    final remoteConfig = AdRemoteConfigService.instance;
    if (!remoteConfig.isInitialized) {
      return;
    }
    if (!remoteConfig.isEnabled(AdPlacementKeys.appOpenInterstitial) &&
        !remoteConfig.isEnabled(AdPlacementKeys.splashOpen)) {
      return;
    }

    final canRequest = await AdConsentService.instance.canRequestAds();
    if (!canRequest) return;

    _isLoading = true;
    final adUnitId = await AdUnitIds.appOpen;

    await AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loadedAt = DateTime.now();
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAdManager: failed to load. $error');
          _ad = null;
          _isLoading = false;
        },
      ),
    );
  }

  Future<bool> waitUntilReadyOrTimeout(Duration timeout) async {
    final remoteConfig = AdRemoteConfigService.instance;
    if (!remoteConfig.isEnabled(AdPlacementKeys.appOpenInterstitial) &&
        !remoteConfig.isEnabled(AdPlacementKeys.splashOpen)) {
      return false;
    }

    final canRequest = await AdConsentService.instance.canRequestAds();
    if (!canRequest) return false;

    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (isAdAvailable) return true;
      await Future.delayed(const Duration(milliseconds: 150));
    }
    return isAdAvailable;
  }

  void show({required VoidCallback onComplete}) {
    if (!isAdAvailable) {
      onComplete();
      return;
    }
    if (_isShowingAd) {
      onComplete();
      return;
    }

    final ad = _ad!;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _ad = null;
        onComplete();
        preload();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _ad = null;
        onComplete();
        preload();
      },
    );

    ad.show();
  }
}

class AppLifecycleAdReporter extends WidgetsBindingObserver {
  DateTime? _backgroundedAt;
  bool _hasShownFirstLaunch = false;

  static const Duration _minimumBackgroundDuration = Duration(seconds: 5);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _maybeShowResumeAd();
    }
  }

  Future<void> _maybeShowResumeAd() async {
    if (!_hasShownFirstLaunch) {
      _hasShownFirstLaunch = true;
      return;
    }
    final backgroundedAt = _backgroundedAt;
    if (backgroundedAt == null) return;
    if (DateTime.now().difference(backgroundedAt) <
        _minimumBackgroundDuration) {
      return;
    }

    final remoteConfig = AdRemoteConfigService.instance;
    if (!remoteConfig.isEnabled(AdPlacementKeys.appResumeAd)) return;

    final canRequest = await AdConsentService.instance.canRequestAds();
    if (!canRequest) return;

    if (!AppOpenAdManager.instance.isAdAvailable) {
      await AppOpenAdManager.instance.preload();
    }
    AppOpenAdManager.instance.show(onComplete: () {});
  }
}
