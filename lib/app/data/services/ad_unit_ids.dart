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
  static const _googleTestBannerSettingsAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const _googleTestBannerSettingsIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const _googleTestAppOpenResumeAndroid = 'ca-app-pub-3940256099942544/9257395921';
  static const _googleTestAppOpenResumeIOS = 'ca-app-pub-3940256099942544/5575463023';

  static Future<String> get appOpen async {
    final native = await AdNativeBridge.get('APP_OPEN_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestAppOpenAndroid : _googleTestAppOpenIOS);
  }

  static Future<String> get banner async {
    final native = await AdNativeBridge.get('BANNER_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestBannerAndroid : _googleTestBannerIOS);
  }

  static Future<String> get native async {
    final native = await AdNativeBridge.get('NATIVE_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get interstitial async {
    final native = await AdNativeBridge.get('INTERSTITIAL_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestInterstitialAndroid : _googleTestInterstitialIOS);
  }

  static Future<String> get nativeLearn async {
    final native = await AdNativeBridge.get('NATIVE_LEARN_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get nativeCategoriesGrid async {
    final native = await AdNativeBridge.get('NATIVE_CATEGORIES_GRID_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get nativeCategoryImageList async {
    final native = await AdNativeBridge.get('NATIVE_CATEGORY_IMAGELIST_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get collapsibleBannerHomeBottom async {
    final native = await AdNativeBridge.get('COLLAPSIBLE_BANNER_HOME_BOTTOM_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestBannerAndroid : _googleTestBannerIOS);
  }

  static Future<String> get collapsibleBannerCategoriesBottom async {
    final native = await AdNativeBridge.get('COLLAPSIBLE_BANNER_CATEGORIES_BOTTOM_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestBannerAndroid : _googleTestBannerIOS);
  }

  static Future<String> get bannerSketchScreen async {
    final native = await AdNativeBridge.get('BANNER_SKETCH_SCREEN_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestBannerAndroid : _googleTestBannerIOS);
  }

  static Future<String> get interstitialSketchPlusButton async {
    final native = await AdNativeBridge.get('INTERSTITIAL_SKETCH_PLUS_BUTTON_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestInterstitialAndroid : _googleTestInterstitialIOS);
  }

  static Future<String> get collapsibleBannerCanvasBottom async {
    final native = await AdNativeBridge.get('COLLAPSIBLE_BANNER_CANVAS_BOTTOM_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestBannerAndroid : _googleTestBannerIOS);
  }

  static Future<String> get bannerSettingsTop async {
    final native = await AdNativeBridge.get('BANNER_SETTINGS_TOP_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestBannerSettingsAndroid : _googleTestBannerSettingsIOS);
  }

  static Future<String> get appClickInterstitial async {
    final native = await AdNativeBridge.get('APP_CLICK_INTERSTITIAL_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestInterstitialAndroid : _googleTestInterstitialIOS);
  }

  static Future<String> get appResumeOpen async {
    final native = await AdNativeBridge.get('APP_RESUME_OPEN_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestAppOpenResumeAndroid : _googleTestAppOpenResumeIOS);
  }

  static Future<String> get welcomeScreenInterstitial async {
    final native = await AdNativeBridge.get('WELCOME_SCREEN_INTERSTITIAL_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestInterstitialAndroid : _googleTestInterstitialIOS);
  }

  static Future<String> get arLanguageScreenNative async {
    final native = await AdNativeBridge.get('AR_LANGUAGE_SCREEN_NATIVE_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get arLanguageScreen2ndNative async {
    final native = await AdNativeBridge.get('AR_LANGUAGE_SCREEN_2ND_NATIVE_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get arLanguageScreen3rdNative async {
    final native = await AdNativeBridge.get('AR_LANGUAGE_SCREEN_3RD_NATIVE_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get fullNativeOnboardingSlide1to2 async {
    final native = await AdNativeBridge.get('FULL_NATIVE_ONBOARDING_SLIDE_1TO2_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get fullNativeOnboardingSlide2to3 async {
    final native = await AdNativeBridge.get('FULL_NATIVE_ONBOARDING_SLIDE_2TO3_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static Future<String> get nativeOnboardingScreen2Native async {
    final native = await AdNativeBridge.get('NATIVE_ONBOARDING_SCREEN2_NATIVE_AD_UNIT_ID');
    return native ?? (Platform.isAndroid ? _googleTestNativeAndroid : _googleTestNativeIOS);
  }

  static bool get isLikelyTestBuild => kDebugMode;
}