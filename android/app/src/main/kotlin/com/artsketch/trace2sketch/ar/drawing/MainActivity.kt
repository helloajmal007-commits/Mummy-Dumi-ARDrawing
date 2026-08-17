package com.artsketch.trace2sketch.ar.drawing

import ads.SmallNativeAdFactory
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {

    private val adConfigChannel = "sketch_flow/ad_config"
    private val nativeAdFactoryId = "smallNativeAd"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, adConfigChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "getAdUnitId") {
                    val key = call.argument<String>("key")
                    val value = when (key) {
                        "APP_OPEN_AD_UNIT_ID" -> BuildConfig.APP_OPEN_AD_UNIT_ID
                        "BANNER_AD_UNIT_ID" -> BuildConfig.BANNER_AD_UNIT_ID
                        "NATIVE_AD_UNIT_ID" -> BuildConfig.NATIVE_AD_UNIT_ID
                        "INTERSTITIAL_AD_UNIT_ID" -> BuildConfig.INTERSTITIAL_AD_UNIT_ID
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
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, nativeAdFactoryId)
    }
}