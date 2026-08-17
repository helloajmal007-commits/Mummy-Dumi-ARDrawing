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
  static const String interstitialHome = 'interstitial_home';
  static const String interstitialWelcome = 'interstitial_welcome';
  static const String appOpenInterstitial = 'app_open_interstitial';
  static const String appResumeAd = 'app_resume_ad';
  static const String splashOpen = 'splash_open';
  static const String rewardedAd = 'rewarded_ad';
  static const String nativeFavTeam = 'native_fav_team';
  static const String nativeFavCompetition = 'native_fav_competition';
  static const String nativeAllGames = 'native_all_games';
  static const String nativeFavorites = 'native_favorites';
  static const String nativeLeagues = 'native_leagues';
  static const String nativeLeagueMatches = 'native_league_matches';
  static const String nativeLiveMatches = 'native_live_matches';
  static const String nativeFinishedMatches = 'native_finished_matches';
  static const String nativeUpcomingMatches = 'native_upcoming_matches';
  static const String nativeLeagueDetails = 'native_league_details';
  static const String nativePlayerDetails = 'native_player_details';
  static const String nativeTeamDetails = 'native_team_details';
  static const String nativeAddFavorites = 'native_add_favorites';
  static const String nativeSelectLanguage1 = 'native_select_language_1';
  static const String nativeSelectLanguage2 = 'native_select_language_2';
  static const String nativeFullScreen = 'native_full_screen';
  static const String nativeGuideScreen2 = 'native_guide_screen_2';
  static const String onboardingLanguageScreen = 'onboarding_language_screen';
  static const String onboardingFlow = 'onboarding_flow';

  static const String nativeHomeSketch = 'native_home_sketch';
}
