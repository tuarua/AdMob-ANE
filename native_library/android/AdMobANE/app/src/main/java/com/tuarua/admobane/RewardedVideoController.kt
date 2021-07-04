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
import com.google.ads.mediation.admob.AdMobAdapter
import com.google.android.gms.ads.*
import com.google.android.gms.ads.rewarded.RewardItem
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import com.google.gson.Gson
import com.tuarua.admobane.Position.*
import com.tuarua.frekotlin.FreKotlinController

class RewardedVideoController(override var context: FREContext?,
                              private val isPersonalised: Boolean) : FreKotlinController, OnUserEarnedRewardListener {
    private val gson = Gson()
    private var _adView: RewardedAd? = null
    private var _showOnLoad: Boolean = true

    fun load(unitId: String, deviceList: List<String>?, targeting: Targeting?, showOnLoad: Boolean) {
        _showOnLoad = showOnLoad
        val activity = this.context?.activity ?: return

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

        RewardedAd.load(activity, unitId, requestBuilder.build(), object : RewardedAdLoadCallback() {
            override fun onAdFailedToLoad(adError: LoadAdError) {
                _adView = null
                dispatchEvent(Constants.ON_LOAD_FAILED, gson.toJson(AdMobEvent(REWARD.ordinal, adError.code)))
            }

            override fun onAdLoaded(rewardedAd: RewardedAd) {
                _adView = rewardedAd
                _adView?.fullScreenContentCallback = object : FullScreenContentCallback() {
                    override fun onAdShowedFullScreenContent() {
                        dispatchEvent(Constants.ON_OPENED, gson.toJson(AdMobEvent(REWARD.ordinal)))
                    }

                    override fun onAdDismissedFullScreenContent() {
                        _adView = null
                        dispatchEvent(Constants.ON_CLOSED, gson.toJson(AdMobEvent(REWARD.ordinal)))
                    }
                }
                if (_showOnLoad) {
                    rewardedAd.show(activity) {
                        dispatchEvent(Constants.ON_REWARDED,
                                gson.toJson(AdMobEventWithReward(REWARD.ordinal, amount = it.amount, type = it.type)))
                    }
                }
                dispatchEvent(Constants.ON_LOADED, gson.toJson(AdMobEvent(REWARD.ordinal)))
            }
        })
    }

    fun show() {
        val activity = this.context?.activity ?: return
        _adView?.show(activity, this)
    }

    override fun onUserEarnedReward(rewardItem: RewardItem) {
        dispatchEvent(Constants.ON_REWARDED,
                gson.toJson(AdMobEventWithReward(REWARD.ordinal, amount = rewardItem.amount, type = rewardItem.type)))
    }

    override val TAG: String?
        get() = this::class.java.canonicalName
}


