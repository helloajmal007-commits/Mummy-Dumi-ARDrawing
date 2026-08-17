import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';

const String kNativeAdFactoryId = 'smallNativeAd';

class NativeAdWidget extends StatefulWidget {
  final String placementKey;
  final double height;

  const NativeAdWidget({
    super.key,
    this.placementKey = AdPlacementKeys.nativeHomeSketch,
    this.height = 330,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _maybeLoad();
  }

  Future<void> _maybeLoad() async {
    if (!AdRemoteConfigService.instance.isEnabled(widget.placementKey)) return;

    final canRequest = await AdConsentService.instance.canRequestAds();
    if (!canRequest) return;
    if (!mounted) return;

    final adUnitId = await AdUnitIds.native;
    if (!mounted) return;

    final ad = NativeAd(
      adUnitId: adUnitId,
      factoryId: kNativeAdFactoryId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _nativeAd = ad as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(
            'NativeAdWidget[${widget.placementKey}]: failed to load. $error',
          );
          ad.dispose();
        },
      ),
    );

    ad.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }
    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(vertical: AppSpace.sm),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: BoxBorder.all(color: Colors.blue),
      ),
      clipBehavior: Clip.antiAlias,
      child: AdWidget(ad: _nativeAd!),
    );
  }
}
