import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';

class AdCacheManager {
  AdCacheManager._();

  static final AdCacheManager instance = AdCacheManager._();

  static const Duration _requestCooldown = Duration(seconds: 2);

  final Map<String, BannerAd> _banners = {};
  final Map<String, bool> _bannerCheckedOut = {};
  final Map<String, Future<BannerAd?>> _bannerLoadsInFlight = {};
  final Map<String, DateTime> _lastBannerRequestAt = {};

  final Map<String, NativeAd> _natives = {};
  final Map<String, bool> _nativeCheckedOut = {};
  final Map<String, Future<NativeAd?>> _nativeLoadsInFlight = {};
  final Map<String, DateTime> _lastNativeRequestAt = {};

  Future<BannerAd?> checkoutBanner(
      String placementKey, {
        AdSize adSize = AdSize.banner,
        String? collapsiblePlacement,
      }) {
    final cached = _banners[placementKey];
    final alreadyCheckedOut = _bannerCheckedOut[placementKey] ?? false;

    if (cached != null && !alreadyCheckedOut) {
      _bannerCheckedOut[placementKey] = true;
      return Future.value(cached);
    }

    final inFlight = _bannerLoadsInFlight[placementKey];
    if (inFlight != null) return inFlight;

    if (_withinCooldown(_lastBannerRequestAt[placementKey])) {
      return Future.value(null);
    }

    final future = _loadBanner(placementKey, adSize, collapsiblePlacement);
    _bannerLoadsInFlight[placementKey] = future;
    return future;
  }

  void releaseBanner(String placementKey) {
    _bannerCheckedOut[placementKey] = false;
  }

  Future<BannerAd?> _loadBanner(
      String placementKey,
      AdSize adSize,
      String? collapsiblePlacement,
      ) async {
    try {
      if (!AdRemoteConfigService.instance.isEnabled(placementKey)) return null;

      final canRequest = await AdConsentService.instance.canRequestAds();
      if (!canRequest) return null;

      _lastBannerRequestAt[placementKey] = DateTime.now();
      final adUnitId = collapsiblePlacement != null
          ? await AdUnitIds.collapsibleBannerHomeBottom
          : await AdUnitIds.banner;
      final completer = Completer<BannerAd?>();

      final request = collapsiblePlacement != null
          ? AdRequest(extras: {'collapsible': collapsiblePlacement})
          : const AdRequest();

      final banner = BannerAd(
        adUnitId: adUnitId,
        size: adSize,
        request: request,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _banners[placementKey]?.dispose();
            _banners[placementKey] = ad as BannerAd;
            _bannerCheckedOut[placementKey] = true;
            if (!completer.isCompleted) completer.complete(ad);
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint(
              'AdCacheManager: banner[$placementKey] failed to load. $error',
            );
            ad.dispose();
            if (!completer.isCompleted) completer.complete(null);
          },
        ),
      );
      banner.load();

      return completer.future;
    } finally {
      _bannerLoadsInFlight.remove(placementKey);
    }
  }

  Future<NativeAd?> checkoutNative(
      String placementKey, {
        required String factoryId,
      }) {
    final cached = _natives[placementKey];
    final alreadyCheckedOut = _nativeCheckedOut[placementKey] ?? false;

    if (cached != null && !alreadyCheckedOut) {
      _nativeCheckedOut[placementKey] = true;
      return Future.value(cached);
    }

    final inFlight = _nativeLoadsInFlight[placementKey];
    if (inFlight != null) return inFlight;

    if (_withinCooldown(_lastNativeRequestAt[placementKey])) {
      return Future.value(null);
    }

    final future = _loadNative(placementKey, factoryId);
    _nativeLoadsInFlight[placementKey] = future;
    return future;
  }

  void releaseNative(String placementKey) {
    _nativeCheckedOut[placementKey] = false;
  }

  Future<NativeAd?> _loadNative(String placementKey, String factoryId) async {
    try {
      if (!AdRemoteConfigService.instance.isEnabled(placementKey)) return null;

      final canRequest = await AdConsentService.instance.canRequestAds();
      if (!canRequest) return null;

      _lastNativeRequestAt[placementKey] = DateTime.now();
      final adUnitId = await AdUnitIds.native;
      final completer = Completer<NativeAd?>();

      final ad = NativeAd(
        adUnitId: adUnitId,
        factoryId: factoryId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            _natives[placementKey]?.dispose();
            _natives[placementKey] = ad as NativeAd;
            _nativeCheckedOut[placementKey] = true;
            if (!completer.isCompleted) completer.complete(ad);
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint(
              'AdCacheManager: native[$placementKey] failed to load. $error',
            );
            ad.dispose();
            if (!completer.isCompleted) completer.complete(null);
          },
        ),
      );
      ad.load();

      return completer.future;
    } finally {
      _nativeLoadsInFlight.remove(placementKey);
    }
  }

  bool _withinCooldown(DateTime? lastRequestAt) {
    if (lastRequestAt == null) return false;
    return DateTime.now().difference(lastRequestAt) < _requestCooldown;
  }

  void disposeAll() {
    for (final ad in _banners.values) {
      ad.dispose();
    }
    _banners.clear();
    _bannerCheckedOut.clear();
    for (final ad in _natives.values) {
      ad.dispose();
    }
    _natives.clear();
    _nativeCheckedOut.clear();
  }
}