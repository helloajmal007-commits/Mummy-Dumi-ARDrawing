import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_cache_manager.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';

const String kNativeAdFactoryId = 'smallNativeAd';

class NativeAdWidget extends StatefulWidget {
  final String placementKey;
  final double height;
  final Future<String>? adUnitIdOverride;

  const NativeAdWidget({
    super.key,
    this.placementKey = AdPlacementKeys.nativeHomeSketch,
    this.height = 88,
    this.adUnitIdOverride,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
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
          factoryId: kNativeAdFactoryId,
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
    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(vertical: AppSpace.sm),
      decoration: BoxDecoration(
        color: AppColors.accentSoft.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: AdWidget(ad: ad),
    );
  }
}
