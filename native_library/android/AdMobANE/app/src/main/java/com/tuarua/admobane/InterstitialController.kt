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

import android.os.Bundle
import com.adobe.fre.FREContext
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback
import com.google.ads.mediation.admob.AdMobAdapter
import com.google.android.gms.ads.*
import com.google.gson.Gson
import com.tuarua.admobane.Position.*
import com.tuarua.frekotlin.FreKotlinController

@Suppress("JoinDeclarationAndAssignment")
class InterstitialController(override var context: FREContext?,
                             private val isPersonalised: Boolean) : FreKotlinController {

    private var _adView: InterstitialAd? = null
    private var _showOnLoad = true
    private val gson = Gson()

    fun load(unitId: String, deviceList: List<String>?, targeting: Targeting?, showOnLoad: Boolean) {
        _showOnLoad = showOnLoad
        val activity = this.context?.activity ?: return
        val context = activity.applicationContext ?: return

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

        configBuilder.setTestDeviceIds(deviceList)

        MobileAds.setRequestConfiguration(configBuilder.build())

        InterstitialAd.load(context, unitId, requestBuilder.build(), object : InterstitialAdLoadCallback() {
            override fun onAdFailedToLoad(adError: LoadAdError) {
                _adView = null

                dispatchEvent(Constants.ON_LOAD_FAILED, gson.toJson(AdMobEvent(INTERSTITIAL.ordinal, adError.code)))
            }

            override fun onAdLoaded(interstitialAd: InterstitialAd) {
                _adView = interstitialAd
                _adView?.fullScreenContentCallback = object: FullScreenContentCallback() {
                    override fun onAdShowedFullScreenContent() {
                        dispatchEvent(Constants.ON_OPENED, gson.toJson(AdMobEvent(INTERSTITIAL.ordinal)))
                    }

                    override fun onAdDismissedFullScreenContent() {
                        _adView = null
                        dispatchEvent(Constants.ON_CLOSED, gson.toJson(AdMobEvent(INTERSTITIAL.ordinal)))
                    }
                }
                if (_showOnLoad) {
                    interstitialAd.show(activity)
                }

                dispatchEvent(Constants.ON_LOADED, gson.toJson(AdMobEvent(INTERSTITIAL.ordinal)))
            }
        })

    }

    fun show() {
        val activity = this.context?.activity ?: return
        _adView?.show(activity)
    }

    override val TAG: String?
        get() = this::class.java.canonicalName

}