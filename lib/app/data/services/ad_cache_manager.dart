import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';

class NativeCheckout {
  final NativeAd? ad;
  final int generation;

  const NativeCheckout(this.ad, this.generation);
}

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
  final Map<String, Future<NativeCheckout>> _nativeLoadsInFlight = {};
  final Map<String, DateTime> _lastNativeRequestAt = {};

  final Map<String, int> _nativeGeneration = {};

  final Map<String, int> _nativeAdGeneration = {};

  final Map<String, int> _nativeCheckedOutGeneration = {};

  Future<BannerAd?> checkoutBanner(
    String placementKey, {
    AdSize adSize = AdSize.banner,
    String? collapsiblePlacement,
    Future<String>? adUnitId,
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

    final future = _loadBanner(
      placementKey,
      adSize,
      collapsiblePlacement,
      adUnitId,
    );
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
    Future<String>? adUnitIdOverride,
  ) async {
    try {
      if (!AdRemoteConfigService.instance.isEnabled(placementKey)) return null;

      final canRequest = await AdConsentService.instance.canRequestAds();
      if (!canRequest) return null;

      _lastBannerRequestAt[placementKey] = DateTime.now();
      final adUnitId =
          await (adUnitIdOverride ??
              (collapsiblePlacement != null
                  ? AdUnitIds.collapsibleBannerHomeBottom
                  : AdUnitIds.banner));
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

      return await completer.future;
    } finally {
      _bannerLoadsInFlight.remove(placementKey);
    }
  }

  Future<NativeAd?> checkoutNative(
    String placementKey, {
    required String factoryId,
    Future<String>? adUnitId,
  }) async {
    final result = await checkoutNativeWithToken(
      placementKey,
      factoryId: factoryId,
      adUnitId: adUnitId,
    );
    return result.ad;
  }

  Future<NativeCheckout> checkoutNativeWithToken(
    String placementKey, {
    required String factoryId,
    Future<String>? adUnitId,
  }) {
    final cached = _natives[placementKey];
    final alreadyCheckedOut = _nativeCheckedOut[placementKey] ?? false;

    if (cached != null && !alreadyCheckedOut) {
      final generation = _nativeAdGeneration[placementKey] ?? 0;
      _nativeCheckedOut[placementKey] = true;
      _nativeCheckedOutGeneration[placementKey] = generation;
      return Future.value(NativeCheckout(cached, generation));
    }

    final inFlight = _nativeLoadsInFlight[placementKey];
    if (inFlight != null) return inFlight;

    if (_withinCooldown(_lastNativeRequestAt[placementKey])) {
      return Future.value(const NativeCheckout(null, -1));
    }

    final future = _loadNative(
      placementKey,
      factoryId,
      adUnitId ?? AdUnitIds.native,
    );
    _nativeLoadsInFlight[placementKey] = future;
    return future;
  }

  bool isCurrentNative(String placementKey, int generation) {
    final ad = _natives[placementKey];
    if (ad == null) return false;
    return (_nativeAdGeneration[placementKey] ?? -1) == generation;
  }

  void releaseNativeGeneration(String placementKey, int generation) {
    if (_nativeCheckedOutGeneration[placementKey] != generation) return;
    _nativeCheckedOut[placementKey] = false;
  }

  void releaseNative(String placementKey) {
    _nativeCheckedOut[placementKey] = false;
  }

  Future<NativeCheckout> _loadNative(
    String placementKey,
    String factoryId,
    Future<String> adUnitIdFuture,
  ) async {
    try {
      if (!AdRemoteConfigService.instance.isEnabled(placementKey)) {
        return const NativeCheckout(null, -1);
      }

      final canRequest = await AdConsentService.instance.canRequestAds();
      if (!canRequest) return const NativeCheckout(null, -1);

      _lastNativeRequestAt[placementKey] = DateTime.now();
      final adUnitId = await adUnitIdFuture;
      final completer = Completer<NativeCheckout>();

      final ad = NativeAd(
        adUnitId: adUnitId,
        factoryId: factoryId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            _natives[placementKey]?.dispose();
            _natives[placementKey] = ad as NativeAd;
            final generation = (_nativeGeneration[placementKey] ?? 0) + 1;
            _nativeGeneration[placementKey] = generation;
            _nativeAdGeneration[placementKey] = generation;
            _nativeCheckedOut[placementKey] = true;
            _nativeCheckedOutGeneration[placementKey] = generation;
            if (!completer.isCompleted) {
              completer.complete(NativeCheckout(ad, generation));
            }
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint(
              'AdCacheManager: native[$placementKey] failed to load. $error',
            );
            ad.dispose();
            if (!completer.isCompleted) {
              completer.complete(const NativeCheckout(null, -1));
            }
          },
        ),
      );
      ad.load();

      return await completer.future;
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
    _nativeGeneration.clear();
    _nativeAdGeneration.clear();
    _nativeCheckedOutGeneration.clear();
  }
}
