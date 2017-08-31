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

import android.view.ViewGroup
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.android.gms.ads.MobileAds
import com.tuarua.frekotlin.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST")
class KotlinController : FreKotlinMainController {
    private lateinit var airView: ViewGroup
    private val TRACE = "TRACE"
    private var deviceList: List<String>? = null

    private var bannerController: BannerController? = null
    private var interstitialController: InterstitialController? = null

    fun isSupported(ctx: FREContext, argv: FREArgv): FREObject? {
        return FreObjectKotlin(true).rawValue.guard { return null }
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val key: String = FreObjectKotlin(argv[0]).value as String // key:String

            val volumeFre = FreObjectKotlin(argv[1]).value
            val volume = ((volumeFre as? Int)?.toDouble() ?: volumeFre as Double).toFloat()
            val muted = FreObjectKotlin(argv[2]).value as Boolean
            airView = context?.activity?.findViewById(android.R.id.content) as ViewGroup
            airView = airView.getChildAt(0) as ViewGroup
            MobileAds.initialize(ctx.activity?.applicationContext, key)
            MobileAds.setAppVolume(volume)
            MobileAds.setAppMuted(muted)

            bannerController = BannerController(_context, airView)
            interstitialController = InterstitialController(ctx)
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return FreObjectKotlin(true).rawValue.guard { return null }
    }

    fun setTestDevices(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val deviceArray = FreArrayKotlin(argv[0]).value
            deviceList = deviceArray.map { it.toString() }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun loadBanner(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 6 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val unitId: String = FreObjectKotlin(argv[0]).value as String
            val adSize: Int = FreObjectKotlin(argv[1]).value as Int
            val targeting: Targeting? = Targeting(FreObjectKotlin(argv[2]))
            val xFre = FreObjectKotlin(argv[3]).value
            val x = ((xFre as? Int)?.toDouble() ?: xFre as Double).toFloat()
            val yFre = FreObjectKotlin(argv[4]).value
            val y = ((yFre as? Int)?.toDouble() ?: yFre as Double).toFloat()
            val hAlign: String = FreObjectKotlin(argv[5]).value as String
            val vAlign: String = FreObjectKotlin(argv[6]).value as String

            bannerController?.load(unitId, adSize, deviceList, targeting, x, y, hAlign, vAlign)
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun clearBanner(ctx: FREContext, argv: FREArgv): FREObject? {
        try {
            bannerController?.clear()
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun getBannerSizes(ctx: FREContext, argv: FREArgv): FREObject? {
        return try {
            FreArrayKotlin(bannerController?.getBannerSizes() ?: intArrayOf(-1)).rawValue
        } catch (e: FreException) {
            e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            FreException(e).getError(Thread.currentThread().stackTrace)
        }
    }

    fun loadInterstitial(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val unitId: String = FreObjectKotlin(argv[0]).value as String
            val targeting: Targeting? = Targeting(FreObjectKotlin(argv[1]))
            val showOnLoad: Boolean = FreObjectKotlin(argv[2]).value as Boolean
            interstitialController?.load(unitId, deviceList, targeting, showOnLoad)
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun showInterstitial(ctx: FREContext, argv: FREArgv): FREObject? {
        try {
            interstitialController?.show()
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    override fun onStarted() {
        super.onStarted()
    }

    override fun onRestarted() {
        super.onRestarted()
    }

    override fun onResumed() {
        super.onResumed()
        bannerController?.adView?.resume()
    }

    override fun onPaused() {
        super.onPaused()
        bannerController?.adView?.pause()
    }

    override fun onStopped() {
        super.onStopped()
    }

    override fun onDestroyed() {
        super.onDestroyed()
        bannerController?.adView?.destroy()
    }
    override fun dispose() {
        super.dispose()
        bannerController?.adView?.destroy()
    }

    override val TAG: String
        get() = this::class.java.canonicalName
    private var _context:FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
        }

}