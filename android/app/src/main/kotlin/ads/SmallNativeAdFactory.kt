package ads

import android.content.Context
import android.view.LayoutInflater
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory
import com.artsketch.trace2sketch.ar.drawing.R

class SmallNativeAdFactory(private val context: Context) : NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val inflater = LayoutInflater.from(context)
        val adView = inflater.inflate(R.layout.native_ad_small, null) as NativeAdView

        val headlineView = adView.findViewById<android.widget.TextView>(R.id.ad_headline)
        val bodyView = adView.findViewById<android.widget.TextView>(R.id.ad_body)
        val iconView = adView.findViewById<android.widget.ImageView>(R.id.ad_icon)
        val callToActionView = adView.findViewById<android.widget.Button>(R.id.ad_call_to_action)
        val mediaView = adView.findViewById<com.google.android.gms.ads.nativead.MediaView>(R.id.ad_media)

        headlineView.text = nativeAd.headline
        adView.headlineView = headlineView

        if (nativeAd.body != null) {
            bodyView.text = nativeAd.body
            bodyView.visibility = android.view.View.VISIBLE
        } else {
            bodyView.visibility = android.view.View.GONE
        }
        adView.bodyView = bodyView

        if (nativeAd.icon != null) {
            iconView.setImageDrawable(nativeAd.icon?.drawable)
            iconView.visibility = android.view.View.VISIBLE
        } else {
            iconView.visibility = android.view.View.GONE
        }
        adView.iconView = iconView

        if (nativeAd.callToAction != null) {
            callToActionView.text = nativeAd.callToAction
            callToActionView.visibility = android.view.View.VISIBLE
        } else {
            callToActionView.visibility = android.view.View.INVISIBLE
        }
        adView.callToActionView = callToActionView

        adView.mediaView = mediaView
        nativeAd.mediaContent?.let { mediaView.mediaContent = it }

        adView.setNativeAd(nativeAd)

        return adView
    }
}