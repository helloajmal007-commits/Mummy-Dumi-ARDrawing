import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sketch_flow/app/data/services/ad_native_bridge.dart';

class AdUnitIds {
  AdUnitIds._();

  static const _googleTestAppOpenAndroid = 'ca-app-pub-3940256099942544/9257395921';
  static const _googleTestAppOpenIOS = 'ca-app-pub-3940256099942544/5575463023';
  static const _googleTestBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const _googleTestBannerIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const _googleTestNativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const _googleTestNativeIOS = 'ca-app-pub-3940256099942544/3986624511';
  static const _googleTestInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const _googleTestInterstitialIOS = 'ca-app-pub-3940256099942544/4411468910';

  static Future<String> get appOpen async {
    final native = await AdNativeBridge.get('APP_OPEN_AD_UNIT_ID');
    return native ??
        (Platform.isAndroid
            ? _googleTestAppOpenAndroid
            : _googleTestAppOpenIOS);
  }

  static Future<String> get banner async {
    final native = await AdNativeBridge.get('BANNER_AD_UNIT_ID');
    return native ??
        (Platform.isAndroid ? _googleTestBannerAndroid : _googleTestBannerIOS);
  }

  static Future<String> get native async {
    final native = await AdNativeBridge.get('NATIVE_AD_UNIT_ID');
    return native ??
        (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get interstitial async {
    final native = await AdNativeBridge.get('INTERSTITIAL_AD_UNIT_ID');
    return native ??
        (Platform.isAndroid
            ? _googleTestInterstitialAndroid
            : _googleTestInterstitialIOS);
  }

  static Future<String> get collapsibleBannerHomeBottom async {
    final native = await AdNativeBridge.get('COLLAPSIBLE_BANNER_HOME_BOTTOM_AD_UNIT_ID');
    return native ??
        (Platform.isAndroid ? _googleTestBannerAndroid : _googleTestBannerIOS);
  }

  static bool get isLikelyTestBuild => kDebugMode;
}
