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

  const NativeAdWidget({
    super.key,
    this.placementKey = AdPlacementKeys.nativeHomeSketch,
    this.height = 88,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _checkedOut = false;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    AdCacheManager.instance
        .checkoutNative(widget.placementKey, factoryId: kNativeAdFactoryId)
        .then((ad) {
          if (!mounted || ad == null) return;
          _checkedOut = true;
          setState(() => _nativeAd = ad);
        });
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
