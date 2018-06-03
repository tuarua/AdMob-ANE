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

import android.view.ViewGroup
import com.adobe.fre.FREArray
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.android.gms.ads.MobileAds
import com.tuarua.frekotlin.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST")
class KotlinController : FreKotlinMainController {
    private lateinit var airView: ViewGroup
    private val TRACE = "TRACE"
    private var scaleFactor: Float = 1.0F
    private var deviceList: List<String>? = null

    private var bannerController: BannerController? = null
    private var interstitialController: InterstitialController? = null
    private var rewardController: RewardedVideoController? = null

    fun isSupported(ctx: FREContext, argv: FREArgv): FREObject? {
        return true.toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 4 } ?: return FreArgException("init")
        val key = String(argv[0])
        val volume = Float(argv[1])
        val muted = Boolean(argv[2])
        val isPersonalised = Boolean(argv[4]) == true
        scaleFactor = Float(argv[3]) ?: 1.0F
        airView = context?.activity?.findViewById(android.R.id.content) as ViewGroup
        airView = airView.getChildAt(0) as ViewGroup
        MobileAds.initialize(ctx.activity?.applicationContext, key)
        volume?.let { MobileAds.setAppVolume(it) }
        muted?.let { MobileAds.setAppMuted(it) }
        bannerController = BannerController(_context, airView, isPersonalised)
        interstitialController = InterstitialController(ctx, isPersonalised)
        rewardController = RewardedVideoController(ctx, isPersonalised)
        return true.toFREObject()
    }

    fun setTestDevices(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setTestDevices")
        val deviceArray: FREArray? = FREArray(argv[0])
        deviceList = List(deviceArray)
        return null
    }

    fun loadBanner(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 6 } ?: return FreArgException("loadBanner")
        val unitId = String(argv[0]) ?: return FreConversionException("unitId")
        val adSize = Int(argv[1]) ?: return FreConversionException("adSize")
        val targeting: Targeting? = Targeting(argv[2])
        val x = Float(argv[3]) ?: return FreConversionException("x")
        val y = Float(argv[4]) ?: return FreConversionException("y")
        val hAlign = String(argv[5]) ?: return FreConversionException("hAlign")
        val vAlign = String(argv[6]) ?: return FreConversionException("vAlign")

        bannerController?.load(unitId, adSize, deviceList, targeting, x * scaleFactor, y * scaleFactor, hAlign, vAlign)
        return null
    }

    fun clearBanner(ctx: FREContext, argv: FREArgv): FREObject? {
        bannerController?.clear()
        return null
    }

    fun getBannerSizes(ctx: FREContext, argv: FREArgv): FREObject? {
        return try {
            FREArray(bannerController?.getBannerSizes() ?: intArrayOf(-1))
        } catch (e: FreException) {
            e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            FreException(e).getError(Thread.currentThread().stackTrace)
        }
    }

    fun loadInterstitial(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("loadInterstitial")
        val unitId = String(argv[0]) ?: return FreConversionException("unitId")
        val targeting: Targeting? = Targeting(argv[1])
        val showOnLoad = Boolean(argv[2]) == true
        interstitialController?.load(unitId, deviceList, targeting, showOnLoad)
        return null
    }

    fun showInterstitial(ctx: FREContext, argv: FREArgv): FREObject? {
        interstitialController?.show()
        return null
    }

    fun loadRewardVideo(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("loadRewardVideo")
        val unitId = String(argv[0]) ?: return FreConversionException("unitId")
        val targeting: Targeting? = Targeting(argv[1])
        val showOnLoad = Boolean(argv[2]) == true
        rewardController?.load(unitId, deviceList, targeting, showOnLoad)
        return null
    }

    fun showRewardVideo(ctx: FREContext, argv: FREArgv): FREObject? {
        rewardController?.show()
        return null
    }

    override fun onResumed() {
        super.onResumed()
        bannerController?.adView?.resume()
        rewardController?.adView?.resume(this.context?.activity)
    }

    override fun onPaused() {
        super.onPaused()
        bannerController?.adView?.pause()
        rewardController?.adView?.pause(this.context?.activity)
    }

    override fun onDestroyed() {
        super.onDestroyed()
        bannerController?.adView?.destroy()
        rewardController?.adView?.destroy(this.context?.activity)
    }

    override fun dispose() {
        super.dispose()
        rewardController?.adView?.destroy(this.context?.activity)
        rewardController = null
        bannerController?.dispose()
        bannerController = null
        interstitialController = null
    }

    override val TAG: String
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
        }

}