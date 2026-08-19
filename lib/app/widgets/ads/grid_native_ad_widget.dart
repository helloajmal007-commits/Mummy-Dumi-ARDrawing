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
  bool _checkedOut = false;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    AdCacheManager.instance
        .checkoutNative(
          widget.placementKey,
          factoryId: kGridNativeAdFactoryId,
          adUnitId: widget.adUnitIdOverride,
        )
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        color: AppColors.surface,
        child: AdWidget(ad: ad),
      ),
    );
  }
}
