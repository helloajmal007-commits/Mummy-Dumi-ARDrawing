import 'package:flutter/foundation.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/data/services/interstitial_ad_manager.dart';

class AppClickInterstitialManager {
  AppClickInterstitialManager._();

  static final AppClickInterstitialManager instance =
      AppClickInterstitialManager._();

  static const String placementKey = AdPlacementKeys.appClickInterstitial;

  int _clickCount = 0;

  bool _suppressUntilCanvasOpens = false;

  void suppressNextCount() {
    _suppressUntilCanvasOpens = true;
  }

  void resetCount() {
    _clickCount = 0;
  }

  void preload() {
    final config = AdRemoteConfigService.instance.clickInterstitialConfig;
    if (!config.show) return;
    InterstitialAdManager.instance.preload(
      placementKey,
      AdUnitIds.appClickInterstitial,
    );
  }

  bool registerClickAndCheckThreshold({String? routeName}) {
    if (_suppressUntilCanvasOpens) {
      if (routeName == '/canvas') {
        _suppressUntilCanvasOpens = false;
      }
      return false;
    }

    final config = AdRemoteConfigService.instance.clickInterstitialConfig;
    if (!config.show) return false;

    _clickCount++;
    debugPrint(
      'AppClickInterstitialManager: click=$_clickCount / ${config.clickThreshold}',
    );

    if (_clickCount >= config.clickThreshold) {
      return true;
    }
    return false;
  }
}
