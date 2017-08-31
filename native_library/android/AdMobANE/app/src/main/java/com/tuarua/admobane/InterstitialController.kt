/*
 *  Copyright 2017 Tua Rua Ltd.
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

import android.view.Gravity
import android.widget.FrameLayout
import android.widget.FrameLayout.*
import com.adobe.fre.FREContext
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.InterstitialAd
import com.google.gson.Gson
import com.tuarua.admobane.Position.*
import com.tuarua.frekotlin.FreKotlinController

@Suppress("JoinDeclarationAndAssignment")
class InterstitialController(override var context: FREContext?) : FreKotlinController, AdListener() {

    private var _adView: InterstitialAd? = null
    private var _showOnLoad:Boolean = true
    private var container: FrameLayout
    private val gson = Gson()

    init {
        container = FrameLayout(this.context?.activity?.applicationContext)
        container.isClickable = false

        val lp = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
        lp.gravity = Gravity.CENTER_HORIZONTAL or Gravity.BOTTOM
        container.layoutParams = lp
    }


    fun load(unitId: String, deviceList: List<String>?, targeting: Targeting?, showOnLoad:Boolean) {
        _adView = InterstitialAd(this.context?.activity?.applicationContext)
        _showOnLoad = showOnLoad
        val av = _adView ?: return
        av.adListener = this
        av.adUnitId = unitId

        val builder = AdRequest.Builder()
        if (targeting != null) {
            builder.setGender(targeting.gender)
            if (targeting.birthday != null) {
                builder.setBirthday(targeting.birthday)
            }
            if (targeting.forChildren != null) {
                val forChildren = targeting.forChildren
                forChildren?.let { builder.tagForChildDirectedTreatment(it) }
            }
        }
        deviceList?.forEach { device -> builder.addTestDevice(device) }
        av.loadAd(builder.build())

    }

    fun show() {
        val av = _adView ?: return
        if (av.isLoaded){
            av.show()
        }
    }

    override fun onAdImpression() {
        super.onAdImpression()
        sendEvent(Constants.ON_IMPRESSION, gson.toJson(AdMobEvent(INTERSTITIAL)))
    }

    override fun onAdLeftApplication() {
        super.onAdLeftApplication()
        sendEvent(Constants.ON_LEFT_APPLICATION, gson.toJson(AdMobEvent(INTERSTITIAL)))
    }

    override fun onAdClicked() {
        super.onAdClicked()
        sendEvent(Constants.ON_CLICKED, gson.toJson(AdMobEvent(INTERSTITIAL)))
    }

    override fun onAdFailedToLoad(p0: Int) {
        super.onAdFailedToLoad(p0)
        sendEvent(Constants.ON_LOAD_FAILED, gson.toJson(AdMobEvent(INTERSTITIAL, p0)))
    }

    override fun onAdClosed() {
        super.onAdClosed()
        sendEvent(Constants.ON_CLOSED, gson.toJson(AdMobEvent(INTERSTITIAL)))
    }

    override fun onAdOpened() {
        super.onAdOpened()
        sendEvent(Constants.ON_OPENED, gson.toJson(AdMobEvent(INTERSTITIAL)))
    }

    override fun onAdLoaded() {
        super.onAdLoaded()

        val av = _adView ?: return
        if(_showOnLoad) {
            av.show()
        }

        sendEvent(Constants.ON_LOADED, gson.toJson(AdMobEvent(INTERSTITIAL)))
    }


    override val TAG: String
        get() = this::class.java.canonicalName

}