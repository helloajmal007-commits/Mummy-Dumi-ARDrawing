import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/services/ad_cache_manager.dart';

const String kFullNativeAdFactoryId = 'fullNativeAd';

class FullNativeAdWidget extends StatefulWidget {
  final String placementKey;
  final Future<String>? adUnitIdOverride;

  final ValueChanged<bool>? onLoadResult;

  const FullNativeAdWidget({
    super.key,
    required this.placementKey,
    this.adUnitIdOverride,
    this.onLoadResult,
  });

  @override
  State<FullNativeAdWidget> createState() => _FullNativeAdWidgetState();
}

class _FullNativeAdWidgetState extends State<FullNativeAdWidget> {
  NativeAd? _nativeAd;
  int? _generation;
  bool _disposed = false;
  bool _resultReported = false;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    AdCacheManager.instance
        .checkoutNativeWithToken(
          widget.placementKey,
          factoryId: kFullNativeAdFactoryId,
          adUnitId: widget.adUnitIdOverride,
        )
        .then((checkout) {
          final ad = checkout.ad;

          if (_disposed) {
            if (ad != null) {
              AdCacheManager.instance.releaseNativeGeneration(
                widget.placementKey,
                checkout.generation,
              );
            }
            return;
          }

          if (ad != null &&
              AdCacheManager.instance.isCurrentNative(
                widget.placementKey,
                checkout.generation,
              )) {
            _generation = checkout.generation;
            setState(() => _nativeAd = ad);
          } else if (ad != null) {
            AdCacheManager.instance.releaseNativeGeneration(
              widget.placementKey,
              checkout.generation,
            );
          }

          _reportResult(ad != null);
        });
  }

  void _reportResult(bool success) {
    if (_resultReported) return;
    _resultReported = true;
    widget.onLoadResult?.call(success);
  }

  @override
  void dispose() {
    _disposed = true;
    final generation = _generation;
    if (generation != null) {
      AdCacheManager.instance.releaseNativeGeneration(
        widget.placementKey,
        generation,
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _nativeAd;
    final generation = _generation;
    if (ad == null ||
        generation == null ||
        !AdCacheManager.instance.isCurrentNative(
          widget.placementKey,
          generation,
        )) {
      return const SizedBox.expand();
    }
    return SizedBox.expand(child: AdWidget(ad: ad));
  }
}
