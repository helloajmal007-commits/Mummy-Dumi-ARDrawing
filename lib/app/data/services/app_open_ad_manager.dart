import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/ad_presentation_state.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/modules/onboarding/views/ad_loading_gate_view.dart';

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

    if (isAdAvailable) {
      return AdConsentService.instance.canRequestAds();
    }
    return false;
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
    if (AdPresentationState.instance.isPresenting) {
      debugPrint('AppOpenAdManager.show: another ad is presenting, skipping show.');
      onComplete();
      return;
    }

    AdPresentationState.instance.markPresenting();

    final ad = _ad!;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        AdPresentationState.instance.markIdle();
        ad.dispose();
        _ad = null;
        onComplete();
        preload();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        AdPresentationState.instance.markIdle();
        ad.dispose();
        _ad = null;
        onComplete();
        preload();
      },
    );

    ad.show();
  }
}

class AppResumeOpenAdManager {
  AppResumeOpenAdManager._();

  static final AppResumeOpenAdManager instance = AppResumeOpenAdManager._();

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
    if (!remoteConfig.isInitialized) return;
    if (!remoteConfig.isEnabled(AdPlacementKeys.appResumeOpenAd)) return;

    _isLoading = true;
    final adUnitId = await AdUnitIds.appResumeOpen;

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
          debugPrint('AppResumeOpenAdManager: failed to load. $error');
          _ad = null;
          _isLoading = false;
        },
      ),
    );
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

  bool _isPresentingResumeGate = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AdPresentationState.instance.isPresenting || _isPresentingResumeGate) {
      return;
    }

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
    if (_isPresentingResumeGate) return;
    if (AdPresentationState.instance.isPresenting) return;

    final backgroundedAt = _backgroundedAt;
    if (backgroundedAt == null) return;
    if (DateTime.now().difference(backgroundedAt) <
        _minimumBackgroundDuration) {
      return;
    }

    final remoteConfig = AdRemoteConfigService.instance;
    if (!remoteConfig.isEnabled(AdPlacementKeys.appResumeOpenAd)) return;

    final canRequest = await AdConsentService.instance.canRequestAds();
    if (!canRequest) return;

    if (AdPresentationState.instance.isPresenting) return;

    _backgroundedAt = null;

    _isPresentingResumeGate = true;
    AdPresentationState.instance.markPresenting();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showResumeGate());
  }

  void _showResumeGate() {
    Get.to(
          () => AdLoadingGateView(
        isReady: () => AppResumeOpenAdManager.instance.isAdAvailable,
        showAd: (onComplete) =>
            AppResumeOpenAdManager.instance.show(onComplete: onComplete),
        onFinished: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.back();
            _isPresentingResumeGate = false;
            AdPresentationState.instance.markIdle();
          });
        },
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 200),
    );
  }
}