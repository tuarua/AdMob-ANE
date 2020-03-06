/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.admobane

import android.annotation.SuppressLint
import android.content.res.Configuration.*
import android.os.Bundle
import android.view.Gravity.*
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.FrameLayout.LayoutParams
import android.widget.FrameLayout.LayoutParams.WRAP_CONTENT
import com.adobe.fre.FREContext
import com.google.ads.mediation.admob.AdMobAdapter
import com.google.android.gms.ads.*
import com.google.gson.Gson
import com.tuarua.admobane.Position.BANNER
import com.tuarua.frekotlin.FreKotlinController


@Suppress("JoinDeclarationAndAssignment")
class BannerController(override var context: FREContext?, airView: ViewGroup,
                       private val isPersonalised: Boolean) : FreKotlinController, AdListener() {

    private var airView: ViewGroup? = airView
    private var _adView: AdView? = null
    private var container: FrameLayout? = null
    private val gson = Gson()
    var adView: AdView?
        get() = _adView
        set(value) {
            _adView = value
        }

    init {
        val applicationContext = this.context?.activity?.applicationContext
        if (applicationContext != null) {
            container = FrameLayout(applicationContext)
            container?.isClickable = false

            val lp = LayoutParams(WRAP_CONTENT, WRAP_CONTENT)
            lp.gravity = CENTER_HORIZONTAL or BOTTOM
            container?.layoutParams = lp
        }
    }

    @SuppressLint("RtlHardcoded")
    fun load(unitId: String, size: Int, deviceList: List<String>?, targeting: Targeting?, x: Float, y: Float, hAlign:
    String, vAlign: String) {
        val existingAv = _adView
        if (existingAv != null) {
            if (existingAv.parent == container) {
                container?.removeView(existingAv)
            }
            existingAv.destroy()
        }

        _adView = AdView(this.context?.activity?.applicationContext)

        val av = _adView ?: return
        av.adListener = this
        av.adUnitId = unitId

        when (size) {
            0 -> av.adSize = AdSize.BANNER
            1 -> av.adSize = AdSize.FULL_BANNER
            2 -> av.adSize = AdSize.LARGE_BANNER
            3 -> av.adSize = AdSize.LEADERBOARD
            4 -> av.adSize = AdSize.MEDIUM_RECTANGLE
            5 -> av.adSize = AdSize.SMART_BANNER
        }

        val lp = LayoutParams(WRAP_CONTENT, WRAP_CONTENT)

        when {
            x > -1 && y > -1 -> {
                container?.x = x
                container?.y = y
                lp.gravity = LEFT or TOP
            }
            else -> {
                var hGravity = 1
                var vGravity = 80
                when (hAlign) {
                    "left" -> hGravity = LEFT
                    "center" -> hGravity = CENTER_HORIZONTAL
                    "right" -> hGravity = RIGHT
                }
                when (vAlign) {
                    "bottom" -> vGravity = BOTTOM
                    "center" -> vGravity = CENTER_VERTICAL
                    "top" -> vGravity = TOP
                }
                lp.gravity = hGravity or vGravity
            }
        }
        container?.layoutParams = lp

        val requestBuilder = AdRequest.Builder()
        if (!isPersonalised) {
            val extras = Bundle()
            extras.putString("npa", "1")
            requestBuilder.addNetworkExtrasBundle(AdMobAdapter::class.java, extras)
        }
        val configBuilder = MobileAds.getRequestConfiguration().toBuilder()
        targeting?.maxAdContentRating?.let {
            configBuilder.setMaxAdContentRating(it)
        }
        targeting?.tagForChildDirectedTreatment?.let {
            configBuilder.setTagForUnderAgeOfConsent(it)
        }
        targeting?.tagForUnderAgeOfConsent?.let {
            configBuilder.setTagForUnderAgeOfConsent(it)
        }
        MobileAds.setRequestConfiguration(configBuilder.build())

        deviceList?.forEach { device -> requestBuilder.addTestDevice(device) }
        av.loadAd(requestBuilder.build())
    }

    fun dispose() {
        clear()
        (airView as ViewGroup).removeView(container)
    }

    fun clear() {
        val av = _adView ?: return
        av.adListener = null
        container?.removeView(av)
        av.destroy()
        _adView = null
    }

    override fun onAdImpression() {
        super.onAdImpression()
        dispatchEvent(Constants.ON_IMPRESSION, gson.toJson(AdMobEvent(BANNER.ordinal)))
    }

    override fun onAdLeftApplication() {
        super.onAdLeftApplication()
        dispatchEvent(Constants.ON_LEFT_APPLICATION, gson.toJson(AdMobEvent(BANNER.ordinal)))
    }

    override fun onAdClicked() {
        super.onAdClicked()
        dispatchEvent(Constants.ON_CLICKED, gson.toJson(AdMobEvent(BANNER.ordinal)))
    }

    override fun onAdFailedToLoad(p0: Int) {
        super.onAdFailedToLoad(p0)
        dispatchEvent(Constants.ON_LOAD_FAILED, gson.toJson(AdMobEvent(BANNER.ordinal, p0)))
    }

    override fun onAdClosed() {
        super.onAdClosed()
        dispatchEvent(Constants.ON_CLOSED, gson.toJson(AdMobEvent(BANNER.ordinal)))
    }

    override fun onAdOpened() {
        super.onAdOpened()
        dispatchEvent(Constants.ON_OPENED, gson.toJson(AdMobEvent(BANNER.ordinal)))
    }

    override fun onAdLoaded() {
        super.onAdLoaded()
        val av = _adView ?: return
        if (av.parent == null) {
            container?.addView(av)
        }
        if (container?.parent == null) {
            airView?.addView(container)
        }

        dispatchEvent(Constants.ON_LOADED, gson.toJson(AdMobEvent(BANNER.ordinal)))

    }

    fun getBannerSizes(): IntArray {
        return when (this.context?.activity?.resources?.configuration?.screenLayout?.and(SCREENLAYOUT_SIZE_MASK)) {
            SCREENLAYOUT_SIZE_LARGE, SCREENLAYOUT_SIZE_XLARGE -> intArrayOf(0, 1, 2, 3,
                    4, 5)
            else -> intArrayOf(0, 2, 5)
        }
    }

    override val TAG: String?
        get() = this::class.java.canonicalName

}
