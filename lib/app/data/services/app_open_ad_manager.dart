import 'dart:async';
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

  /// Loads the ad as soon as remote config allows it.
  /// Does NOT wait for consent — the SDK is initialized with default
  /// (non-personalized-capable) settings and it's fine to issue the
  /// ad request in parallel with consent gathering.
  Future<void> preload() async {
    if (_isLoading || isAdAvailable) return;

    final remoteConfig = AdRemoteConfigService.instance;
    if (!remoteConfig.isInitialized) return;
    if (!remoteConfig.isEnabled(AdPlacementKeys.appOpenInterstitial) &&
        !remoteConfig.isEnabled(AdPlacementKeys.splashOpen)) {
      return;
    }

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

  /// Waits until the ad is loaded AND consent has resolved to a
  /// state where we're allowed to show it.
  Future<bool> waitUntilReadyOrTimeout(Duration timeout) async {
    final remoteConfig = AdRemoteConfigService.instance;
    if (!remoteConfig.isEnabled(AdPlacementKeys.appOpenInterstitial) &&
        !remoteConfig.isEnabled(AdPlacementKeys.splashOpen)) {
      return false;
    }

    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (isAdAvailable) {
        final canRequest = await AdConsentService.instance.canRequestAds();
        if (canRequest) return true;
      }
      await Future.delayed(const Duration(milliseconds: 150));
    }

    // Final check at deadline
    if (isAdAvailable) {
      return AdConsentService.instance.canRequestAds();
    }
    return false;
  }

  /// Only call this once consent has been confirmed resolved.
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
