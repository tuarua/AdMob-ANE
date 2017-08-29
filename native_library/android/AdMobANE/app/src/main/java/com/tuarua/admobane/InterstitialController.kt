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

import android.util.Log
import android.view.Gravity
import android.widget.FrameLayout
import com.adobe.fre.FREContext
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.InterstitialAd
import com.tuarua.frekotlin.sendEvent
import com.tuarua.frekotlin.trace
import org.json.JSONException
import org.json.JSONObject

@Suppress("JoinDeclarationAndAssignment")
class InterstitialController(private var context: FREContext) : AdListener() {
    private var _adView: InterstitialAd? = null
    private var _showOnLoad:Boolean = true
    private var container: FrameLayout
    var adView: InterstitialAd?
        get() = _adView
        set(value) {
            _adView = value
        }
    fun load(unitId: String, deviceList: List<String>?, targeting: Targeting?, showOnLoad:Boolean) {
        _adView = InterstitialAd(this.context.activity?.applicationContext)
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
        val props = JSONObject()
        try {
            props.put("position", Position.INTERSTITIAL)
            sendEvent(Constants.ON_IMPRESSION, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdLeftApplication() {
        super.onAdLeftApplication()
        val props = JSONObject()
        try {
            props.put("position", Position.INTERSTITIAL)
            sendEvent(Constants.ON_LEFT_APPLICATION, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdClicked() {
        super.onAdClicked()
        val props = JSONObject()
        try {
            props.put("position", Position.INTERSTITIAL)
            sendEvent(Constants.ON_CLICKED, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdFailedToLoad(p0: Int) {
        super.onAdFailedToLoad(p0)
        val props = JSONObject()
        try {
            props.put("position", Position.INTERSTITIAL)
            props.put("errorCode", p0)
            sendEvent(Constants.ON_LOAD_FAILED, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdClosed() {
        super.onAdClosed()
        val props = JSONObject()
        try {
            props.put("position", Position.INTERSTITIAL)
            sendEvent(Constants.ON_CLOSED, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdOpened() {
        super.onAdOpened()
        val props = JSONObject()
        try {
            props.put("position", Position.INTERSTITIAL)
            sendEvent(Constants.ON_OPENED, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdLoaded() {
        super.onAdLoaded()

        val av = _adView ?: return
        if(_showOnLoad) {
            av.show()
        }

        val props = JSONObject()
        try {
            props.put("position", Position.INTERSTITIAL)
            sendEvent(Constants.ON_LOADED, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }

    }

    private fun trace(vararg value: Any?) {
        context.trace(TAG, value)
    }

    private fun sendEvent(name: String, value: String) {
        context.sendEvent(name, value)
    }

    companion object {
        private var TAG = InterstitialController::class.java.canonicalName
    }

    init {
        container = FrameLayout(this.context.activity?.applicationContext)
        container.isClickable = false

        val lp = FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT)
        lp.gravity = Gravity.CENTER_HORIZONTAL or Gravity.BOTTOM
        container.layoutParams = lp
    }


}