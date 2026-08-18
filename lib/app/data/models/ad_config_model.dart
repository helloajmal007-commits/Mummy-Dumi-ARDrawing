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
}
