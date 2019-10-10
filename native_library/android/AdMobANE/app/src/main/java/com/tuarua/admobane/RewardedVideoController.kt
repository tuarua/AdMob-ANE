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
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.reward.RewardItem
import com.google.android.gms.ads.reward.RewardedVideoAd
import com.google.android.gms.ads.reward.RewardedVideoAdListener
import com.google.gson.Gson
import com.tuarua.admobane.Position.*
import com.tuarua.frekotlin.FreKotlinController

class RewardedVideoController(override var context: FREContext?,
                              private val isPersonalised: Boolean) : FreKotlinController, RewardedVideoAdListener {
    private val gson = Gson()
    private var _adView: RewardedVideoAd? = null
    private var _showOnLoad: Boolean = true
    var adView: RewardedVideoAd?
        get() = _adView
        set(value) {
            _adView = value
        }

    fun load(unitId: String, deviceList: List<String>?, targeting: Targeting?, showOnLoad: Boolean) {
        _adView = MobileAds.getRewardedVideoAdInstance(this.context?.activity)
        _showOnLoad = showOnLoad
        val av = _adView ?: return
        av.rewardedVideoAdListener = this

        val builder = AdRequest.Builder()
        if (!isPersonalised) {
            val extras = Bundle()
            extras.putString("npa", "1")
            builder.addNetworkExtrasBundle(AdMobAdapter::class.java, extras)
        }
        if (targeting != null) {
            if (targeting.forChildren != null) {
                val forChildren = targeting.forChildren
                forChildren?.let { builder.tagForChildDirectedTreatment(it) }
            }
        }
        deviceList?.forEach { device -> builder.addTestDevice(device) }
        av.loadAd(unitId, builder.build())
    }

    fun show() {
        val av = _adView ?: return
        if (av.isLoaded) {
            av.show()
        }
    }

    override fun onRewardedVideoAdClosed() {
        dispatchEvent(Constants.ON_CLOSED, gson.toJson(AdMobEvent(REWARD.ordinal)))
    }

    override fun onRewardedVideoAdLeftApplication() {
        dispatchEvent(Constants.ON_LEFT_APPLICATION, gson.toJson(AdMobEvent(REWARD.ordinal)))
    }

    override fun onRewardedVideoAdLoaded() {
        val av = _adView ?: return
        if (_showOnLoad) {
            av.show()
        }
        dispatchEvent(Constants.ON_LOADED, gson.toJson(AdMobEvent(REWARD.ordinal)))
    }

    override fun onRewardedVideoAdOpened() {
        dispatchEvent(Constants.ON_OPENED, gson.toJson(AdMobEvent(REWARD.ordinal)))
    }

    override fun onRewarded(rewardItem: RewardItem?) {
        if (rewardItem != null) {
            dispatchEvent(Constants.ON_REWARDED,
                    gson.toJson(AdMobEventWithReward(REWARD.ordinal, amount = rewardItem.amount, type = rewardItem.type)))
        } else {
            dispatchEvent(Constants.ON_REWARDED, gson.toJson(AdMobEventWithReward(REWARD.ordinal)))
        }
    }

    override fun onRewardedVideoCompleted() {
        dispatchEvent(Constants.ON_VIDEO_COMPLETE, gson.toJson(AdMobEvent(REWARD.ordinal)))
    }

    override fun onRewardedVideoStarted() {
        dispatchEvent(Constants.ON_VIDEO_STARTED, gson.toJson(AdMobEvent(REWARD.ordinal)))
    }

    override fun onRewardedVideoAdFailedToLoad(p0: Int) {
        dispatchEvent(Constants.ON_LOAD_FAILED, gson.toJson(AdMobEvent(REWARD.ordinal, p0)))
    }

    override val TAG: String?
        get() = this::class.java.canonicalName
}


