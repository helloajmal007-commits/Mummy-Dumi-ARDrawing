import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/app_open_ad_manager.dart';
import 'package:sketch_flow/app/localization/app_translations.dart';
import 'package:sketch_flow/app/localization/locale_controller.dart';
import 'package:sketch_flow/app/modules/settings/controllers/settings_controller.dart';
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
  
  await AdRemoteConfigService.instance.initialize();
  await MobileAds.instance.initialize();
  unawaited(_bootstrapAdsConsentAndPreload());

  runApp(const SketchFlowApp());
}

Future<void> _bootstrapAdsConsentAndPreload() async {
  await AdConsentService.instance.requestConsentIfNeeded();
  await AppOpenAdManager.instance.preload();
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
      defaultTransition: Transition.cupertino,
    );
  }
}