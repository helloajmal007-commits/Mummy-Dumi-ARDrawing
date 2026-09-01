import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/services/ad_cache_manager.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';

const String kGridNativeAdFactoryId = 'gridNativeAd';

class GridNativeAdWidget extends StatefulWidget {
  final String placementKey;
  final Future<String>? adUnitIdOverride;

  const GridNativeAdWidget({
    super.key,
    required this.placementKey,
    this.adUnitIdOverride,
  });

  @override
  State<GridNativeAdWidget> createState() => _GridNativeAdWidgetState();
}

class _GridNativeAdWidgetState extends State<GridNativeAdWidget> {
  NativeAd? _nativeAd;
  int? _generation;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    AdCacheManager.instance
        .checkoutNativeWithToken(
          widget.placementKey,
          factoryId: kGridNativeAdFactoryId,
          adUnitId: widget.adUnitIdOverride,
        )
        .then((checkout) {
          final ad = checkout.ad;
          if (ad == null) return;

          if (_disposed ||
              !AdCacheManager.instance.isCurrentNative(
                widget.placementKey,
                checkout.generation,
              )) {
            AdCacheManager.instance.releaseNativeGeneration(
              widget.placementKey,
              checkout.generation,
            );
            return;
          }

          _generation = checkout.generation;
          setState(() => _nativeAd = ad);
        });
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
      return const SizedBox.shrink();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        color: AppColors.surface,
        child: AdWidget(ad: ad),
      ),
    );
  }
}
