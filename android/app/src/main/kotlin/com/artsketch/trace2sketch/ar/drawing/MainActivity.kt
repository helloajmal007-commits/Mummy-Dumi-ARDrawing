package com.artsketch.trace2sketch.ar.drawing

import ads.GridNativeAdFactory
import ads.SmallNativeAdFactory
import ads.FullNativeAdFactory
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {

    private val adConfigChannel = "sketch_flow/ad_config"
    private val nativeAdFactoryId = "smallNativeAd"
    private val gridNativeAdFactoryId = "gridNativeAd"

    private val fullNativeAdFactoryId = "fullNativeAd"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, adConfigChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "getAdUnitId") {
                    val key = call.argument<String>("key")
                    val value = when (key) {
                        "APP_OPEN_AD_UNIT_ID" -> BuildConfig.APP_OPEN_AD_UNIT_ID
                        "COLLAPSIBLE_BANNER_HOME_BOTTOM_AD_UNIT_ID" -> BuildConfig.COLLAPSIBLE_BANNER_HOME_BOTTOM_AD_UNIT_ID
                        "NATIVE_LEARN_AD_UNIT_ID" -> BuildConfig.NATIVE_LEARN_AD_UNIT_ID

                        "NATIVE_CATEGORIES_GRID_AD_UNIT_ID" -> BuildConfig.NATIVE_CATEGORIES_GRID_AD_UNIT_ID
                        "NATIVE_CATEGORY_IMAGELIST_AD_UNIT_ID" -> BuildConfig.NATIVE_CATEGORY_IMAGELIST_AD_UNIT_ID
                        "COLLAPSIBLE_BANNER_CATEGORIES_BOTTOM_AD_UNIT_ID" -> BuildConfig.COLLAPSIBLE_BANNER_CATEGORIES_BOTTOM_AD_UNIT_ID

                        "BANNER_SKETCH_SCREEN_AD_UNIT_ID" -> BuildConfig.BANNER_SKETCH_SCREEN_AD_UNIT_ID
                        "INTERSTITIAL_SKETCH_PLUS_BUTTON_AD_UNIT_ID" -> BuildConfig.INTERSTITIAL_SKETCH_PLUS_BUTTON_AD_UNIT_ID
                        "COLLAPSIBLE_BANNER_CANVAS_BOTTOM_AD_UNIT_ID" -> BuildConfig.COLLAPSIBLE_BANNER_CANVAS_BOTTOM_AD_UNIT_ID

                        "BANNER_SETTINGS_TOP_AD_UNIT_ID" -> BuildConfig.BANNER_SETTINGS_TOP_AD_UNIT_ID
                        "APP_CLICK_INTERSTITIAL_AD_UNIT_ID" -> BuildConfig.APP_CLICK_INTERSTITIAL_AD_UNIT_ID

                        "APP_RESUME_OPEN_AD_UNIT_ID" -> BuildConfig.APP_RESUME_OPEN_AD_UNIT_ID
                        "WELCOME_SCREEN_INTERSTITIAL_AD_UNIT_ID" -> BuildConfig.WELCOME_SCREEN_INTERSTITIAL_AD_UNIT_ID

                        "AR_LANGUAGE_SCREEN_NATIVE_AD_UNIT_ID" -> BuildConfig.AR_LANGUAGE_SCREEN_NATIVE_AD_UNIT_ID
                        "AR_LANGUAGE_SCREEN_2ND_NATIVE_AD_UNIT_ID" -> BuildConfig.AR_LANGUAGE_SCREEN_2ND_NATIVE_AD_UNIT_ID
                        "AR_LANGUAGE_SCREEN_3RD_NATIVE_AD_UNIT_ID" -> BuildConfig.AR_LANGUAGE_SCREEN_3RD_NATIVE_AD_UNIT_ID
                        "FULL_NATIVE_ONBOARDING_SLIDE_1TO2_AD_UNIT_ID" -> BuildConfig.FULL_NATIVE_ONBOARDING_SLIDE_1TO2_AD_UNIT_ID
                        "FULL_NATIVE_ONBOARDING_SLIDE_2TO3_AD_UNIT_ID" -> BuildConfig.FULL_NATIVE_ONBOARDING_SLIDE_2TO3_AD_UNIT_ID
                        "NATIVE_ONBOARDING_SCREEN2_NATIVE_AD_UNIT_ID" -> BuildConfig.NATIVE_ONBOARDING_SCREEN2_NATIVE_AD_UNIT_ID
                        else -> null
                    }
                    result.success(value)
                } else {
                    result.notImplemented()
                }
            }

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            nativeAdFactoryId,
            SmallNativeAdFactory(this)
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            gridNativeAdFactoryId,
            GridNativeAdFactory(this)
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            fullNativeAdFactoryId,
            FullNativeAdFactory(this)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, nativeAdFactoryId)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, gridNativeAdFactoryId)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, fullNativeAdFactoryId)
    }
}