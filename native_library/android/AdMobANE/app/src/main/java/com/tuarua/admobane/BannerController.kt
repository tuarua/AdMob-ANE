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

import android.annotation.SuppressLint
import android.content.res.Configuration
import android.util.Log
import android.view.Gravity.*
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.LinearLayout
import com.adobe.fre.FREContext
import com.google.android.gms.ads.*
import com.tuarua.frekotlin.sendEvent
import com.tuarua.frekotlin.trace
import org.json.JSONException
import org.json.JSONObject

@Suppress("JoinDeclarationAndAssignment")
class BannerController(private var context: FREContext, airView: ViewGroup) : AdListener() {
    private var airView: ViewGroup? = airView
    private var _adView: AdView? = null
    private var container: FrameLayout
    var adView: AdView?
        get() = _adView
        set(value) {
            _adView = value
        }

    @SuppressLint("RtlHardcoded")
    fun load(unitId: String, size: Int, deviceList: List<String>?, targeting: Targeting?, x: Float, y: Float, hAlign:
    String, vAlign: String) {

        val existingAv = _adView
        if (existingAv != null) {
            if (existingAv.parent == container) {
                container.removeView(existingAv)
            }
            existingAv.destroy()
        }

        _adView = AdView(this.context.activity?.applicationContext)

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

        val lp = FrameLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT)

        when {
            x > -1 && y > -1 -> {
                container.x = x
                container.y = y
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
        container.layoutParams = lp


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

    fun clear() {
        val av = _adView ?: return
        av.adListener = null
        container.removeView(av)
        av.destroy()
        _adView = null
    }

    override fun onAdImpression() {
        super.onAdImpression()
        val props = JSONObject()
        try {
            props.put("position", Position.BANNER)
            sendEvent(Constants.ON_IMPRESSION, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdLeftApplication() {
        super.onAdLeftApplication()
        val props = JSONObject()
        try {
            props.put("position", Position.BANNER)
            sendEvent(Constants.ON_LEFT_APPLICATION, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdClicked() {
        super.onAdClicked()
        val props = JSONObject()
        try {
            props.put("position", Position.BANNER)
            sendEvent(Constants.ON_CLICKED, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdFailedToLoad(p0: Int) {
        super.onAdFailedToLoad(p0)
        val props = JSONObject()
        try {
            props.put("position", Position.BANNER)
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
            props.put("position", Position.BANNER)
            sendEvent(Constants.ON_CLOSED, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdOpened() {
        super.onAdOpened()
        val props = JSONObject()
        try {
            props.put("position", Position.BANNER)
            sendEvent(Constants.ON_OPENED, props.toString())
        } catch (e: JSONException) {
            Log.e(TAG, e.toString())
        }
    }

    override fun onAdLoaded() {
        super.onAdLoaded()
        val av = _adView ?: return
        if (av.parent == null) {
            container.addView(av)
        }
        if (container.parent == null) {
            airView?.addView(container)
        }

        val props = JSONObject()
        try {
            props.put("position", Position.BANNER)
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
        private var TAG = BannerController::class.java.canonicalName
    }

    init {
        container = FrameLayout(this.context.activity?.applicationContext)
        container.isClickable = false

        val lp = FrameLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT)
        lp.gravity = CENTER_HORIZONTAL or BOTTOM
        container.layoutParams = lp
    }

    fun getBannerSizes(): IntArray {
        val screenSize = this.context.activity.resources.configuration.screenLayout and Configuration
                .SCREENLAYOUT_SIZE_MASK

        return when (screenSize) {
            Configuration.SCREENLAYOUT_SIZE_LARGE, Configuration.SCREENLAYOUT_SIZE_XLARGE -> intArrayOf(0, 1, 2, 3,
                    4, 5)
            else -> intArrayOf(0, 2, 5)
        }
    }


}