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
  bool _checkedOut = false;
  bool _resultReported = false;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    AdCacheManager.instance
        .checkoutNative(
          widget.placementKey,
          factoryId: kFullNativeAdFactoryId,
          adUnitId: widget.adUnitIdOverride,
        )
        .then((ad) {
          if (!mounted) return;
          if (ad != null) {
            _checkedOut = true;
            setState(() => _nativeAd = ad);
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
    if (_checkedOut) {
      AdCacheManager.instance.releaseNative(widget.placementKey);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _nativeAd;
    if (ad == null) {
      return const SizedBox.expand();
    }
    return SizedBox.expand(child: AdWidget(ad: ad));
  }
}
