import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_cache_manager.dart';

class BannerAdWidget extends StatefulWidget {
  final String placementKey;
  final AdSize adSize;

  /// Pass `'top'` or `'bottom'` to request a collapsible banner anchored
  /// to that edge. Leave null for a standard, non-collapsible banner.
  final String? collapsiblePlacement;

  const BannerAdWidget({
    super.key,
    this.placementKey = AdPlacementKeys.collapsableBannerHomeBottom,
    this.adSize = AdSize.banner,
    this.collapsiblePlacement,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _checkedOut = false;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    AdCacheManager.instance
        .checkoutBanner(
      widget.placementKey,
      adSize: widget.adSize,
      collapsiblePlacement: widget.collapsiblePlacement,
    )
        .then((ad) {
      if (!mounted || ad == null) return;
      _checkedOut = true;
      setState(() => _bannerAd = ad);
    });
  }

  @override
  void dispose() {
    if (_checkedOut) {
      AdCacheManager.instance.releaseBanner(widget.placementKey);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (ad == null) {
      return const SizedBox.shrink();
    }
    return Container(
      alignment: Alignment.center,
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}