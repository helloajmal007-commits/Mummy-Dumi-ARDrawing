import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_cache_manager.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/data/services/app_click_interstitial_manager.dart';
import 'package:sketch_flow/app/data/services/app_open_ad_manager.dart';
import 'package:sketch_flow/app/data/services/push_notification_service.dart';
import 'package:sketch_flow/app/localization/app_translations.dart';
import 'package:sketch_flow/app/localization/locale_controller.dart';
import 'package:sketch_flow/app/modules/settings/controllers/settings_controller.dart';
import 'package:sketch_flow/app/routes/app_nav_click_observer.dart';
import 'package:sketch_flow/app/widgets/ads/full_native_ad_widget.dart';
import 'package:sketch_flow/app/widgets/ads/native_ad_widget.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await GetStorage.init();
  Get.put(SettingsController(), permanent: true);
  Get.put(LocaleController(), permanent: true);

  await PushNotificationService.instance.initialize();

  await AdRemoteConfigService.instance.initialize();
  await MobileAds.instance.initialize();
  unawaited(_bootstrapAdsConsentAndPreload());

  runApp(const SketchFlowApp());
}

Future<void> _bootstrapAdsConsentAndPreload() async {
  await Future.wait([
    AdConsentService.instance.requestConsentIfNeeded(),
    AppOpenAdManager.instance.preload(),
  ]);
  AppClickInterstitialManager.instance.preload();
  _preloadOnboardingAndLanguageNatives();
}

void _preloadOnboardingAndLanguageNatives() {
  AdCacheManager.instance
      .checkoutNative(
        AdPlacementKeys.arLanguageScreenNative,
        factoryId: kNativeAdFactoryId,
        adUnitId: AdUnitIds.arLanguageScreenNative,
      )
      .then(
        (_) => AdCacheManager.instance.releaseNative(
          AdPlacementKeys.arLanguageScreenNative,
        ),
      );

  AdCacheManager.instance
      .checkoutNative(
        AdPlacementKeys.arLanguageScreen2ndNative,
        factoryId: kNativeAdFactoryId,
        adUnitId: AdUnitIds.arLanguageScreen2ndNative,
      )
      .then(
        (_) => AdCacheManager.instance.releaseNative(
          AdPlacementKeys.arLanguageScreen2ndNative,
        ),
      );

  AdCacheManager.instance
      .checkoutNative(
        AdPlacementKeys.arLanguageScreen3rdNative,
        factoryId: kNativeAdFactoryId,
        adUnitId: AdUnitIds.arLanguageScreen3rdNative,
      )
      .then(
        (_) => AdCacheManager.instance.releaseNative(
          AdPlacementKeys.arLanguageScreen3rdNative,
        ),
      );

  AdCacheManager.instance
      .checkoutNative(
        AdPlacementKeys.nativeOnboardingScreen2Native,
        factoryId: kNativeAdFactoryId,
        adUnitId: AdUnitIds.nativeOnboardingScreen2Native,
      )
      .then(
        (_) => AdCacheManager.instance.releaseNative(
          AdPlacementKeys.nativeOnboardingScreen2Native,
        ),
      );

  AdCacheManager.instance
      .checkoutNative(
        AdPlacementKeys.fullNativeOnboardingSlide1to2,
        factoryId: kFullNativeAdFactoryId,
        adUnitId: AdUnitIds.fullNativeOnboardingSlide1to2,
      )
      .then(
        (_) => AdCacheManager.instance.releaseNative(
          AdPlacementKeys.fullNativeOnboardingSlide1to2,
        ),
      );

  AdCacheManager.instance
      .checkoutNative(
        AdPlacementKeys.fullNativeOnboardingSlide2to3,
        factoryId: kFullNativeAdFactoryId,
        adUnitId: AdUnitIds.fullNativeOnboardingSlide2to3,
      )
      .then(
        (_) => AdCacheManager.instance.releaseNative(
          AdPlacementKeys.fullNativeOnboardingSlide2to3,
        ),
      );
}

class SketchFlowApp extends StatefulWidget {
  const SketchFlowApp({super.key});

  @override
  State<SketchFlowApp> createState() => _SketchFlowAppState();
}

class _SketchFlowAppState extends State<SketchFlowApp> {
  final AppLifecycleAdReporter _lifecycleAdReporter = AppLifecycleAdReporter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleAdReporter);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleAdReporter);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    return GetMaterialApp(
      title: 'SketchFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      translations: AppTranslations(),
      locale: localeController.currentLocale.value,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
      navigatorObservers: [AppNavClickObserver()],
      defaultTransition: Transition.cupertino,
    );
  }
}
