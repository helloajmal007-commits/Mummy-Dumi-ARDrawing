class AdUnitConfig {
  final bool show;
  final int priority;

  const AdUnitConfig({required this.show, required this.priority});

  factory AdUnitConfig.fromJson(Map<String, dynamic> json) {
    return AdUnitConfig(
      show: json['show'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 99,
    );
  }

  factory AdUnitConfig.disabled() =>
      const AdUnitConfig(show: false, priority: 99);
}

class AdPlacementKeys {
  AdPlacementKeys._();

  static const String bannerHome = 'banner_home';
  static const String collapsableBannerHomeBottom = 'collapse_banner_home_bottom';
  static const String appOpenInterstitial = 'app_open_interstitial';
  static const String appResumeAd = 'app_resume_ad';
  static const String splashOpen = 'splash_open';

  static const String nativeHomeSketch = 'native_home_sketch';
  static const String nativeLearnTutorials = 'native_learn_tutorials';

  static const String nativeCategoriesGrid = 'native_categories_grid';
  static const String bannerCategoriesBottom = 'banner_categories_bottom';
  static const String nativeCategoryImageList = 'native_category_imagelist';

  static const String bannerSketchScreen = 'banner_sketch_screen';
  static const String interstitialSketchPlusButton = 'interstitial_sketch_plus_button';
  static const String collapsibleBannerCanvasBottom = 'collapsible_banner_canvas_bottom';

  static const String bannerSettingsTop = 'banner_settings_top';
  static const String appClickInterstitial = 'app_click_Inters';

  static const String appResumeOpenAd = 'on_resume_ad _app_open';
  static const String welcomeScreenInterstitial = 'welcome_screen_interstitial';

  static const String arLanguageScreenNative = 'ar_language_screen_native';
  static const String arLanguageScreen2ndNative = 'ar_language_screen_2nd_native';
  static const String arLanguageScreen3rdNative = 'ar_language_screen_3rd_native';
  static const String fullNativeOnboardingSlide1to2 = 'full_native_onboarding_slide_1to2';
  static const String fullNativeOnboardingSlide2to3 = 'full_native_onboarding_slide_2to3';
  static const String nativeOnboardingScreen2Native = 'native_onboarding_screen2_native';
}

class AdClickInterstitialConfig {
  final bool show;
  final int clickThreshold;

  const AdClickInterstitialConfig({
    required this.show,
    required this.clickThreshold,
  });

  factory AdClickInterstitialConfig.fromJson(Map<String, dynamic> json) {
    return AdClickInterstitialConfig(
      show: json['show'] as bool? ?? false,
      clickThreshold: (json['clickThreshold'] as num?)?.toInt() ?? 3,
    );
  }

  factory AdClickInterstitialConfig.disabled() =>
      const AdClickInterstitialConfig(show: false, clickThreshold: 3);
}
