package ads

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory
import com.artsketch.trace2sketch.ar.drawing.R

class FullNativeAdFactory(private val context: Context) : NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val inflater = LayoutInflater.from(context)
        val adView = inflater.inflate(R.layout.native_ad_full, null) as NativeAdView

        val headlineView = adView.findViewById<android.widget.TextView>(R.id.ad_headline)
        val bodyView = adView.findViewById<android.widget.TextView>(R.id.ad_body)
        val iconView = adView.findViewById<android.widget.ImageView>(R.id.ad_icon)
        val mediaView = adView.findViewById<com.google.android.gms.ads.nativead.MediaView>(R.id.ad_media)
        val callToActionView = adView.findViewById<android.widget.Button>(R.id.ad_call_to_action)

        headlineView.text = nativeAd.headline
        adView.headlineView = headlineView

        if (nativeAd.body != null) {
            bodyView.text = nativeAd.body
            bodyView.visibility = View.VISIBLE
        } else {
            bodyView.visibility = View.GONE
        }
        adView.bodyView = bodyView

        // Full-screen placement: register the MediaView so video/large
        // image creatives render, unlike the compact small-native layout.
        adView.mediaView = mediaView
        mediaView.setMediaContent(nativeAd.mediaContent!!)

        if (nativeAd.icon != null) {
            iconView.setImageDrawable(nativeAd.icon?.drawable)
            iconView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
        }
        adView.iconView = iconView

        if (nativeAd.callToAction != null) {
            callToActionView.text = nativeAd.callToAction
            callToActionView.visibility = View.VISIBLE
        } else {
            callToActionView.visibility = View.INVISIBLE
        }
        adView.callToActionView = callToActionView

        adView.setNativeAd(nativeAd)

        return adView
    }
}