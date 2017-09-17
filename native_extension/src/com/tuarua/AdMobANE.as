package com.tuarua {
import com.tuarua.admobane.AdMobEvent;
import com.tuarua.admobane.Banner;
import com.tuarua.admobane.Interstitial;
import com.tuarua.admobane.RewardVideo;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class AdMobANE extends EventDispatcher {
    private static const NAME:String = "AdMobANE";
    private var ctx:ExtensionContext;
    private var _isInited:Boolean;
    private var _isSupported:Boolean = false;
    private var argsAsJSON:Object;
    private static const TRACE:String = "TRACE";
    private var _testDevices:Vector.<String> = new <String>[];
    private var _banner:Banner;
    private var _interstitial:Interstitial;
    private var _rewardVideo:RewardVideo;

    public function AdMobANE() {
        initiate();
    }

    /**
     * This method is omitted from the output. * * @private
     */
    private function initiate():void {
        trace("[" + NAME + "] Initalizing ANE...");
        try {
            ctx = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
            ctx.addEventListener(StatusEvent.STATUS, gotEvent);
            _isSupported = ctx.call("isSupported");
            _banner = new Banner(ctx);
            _interstitial = new Interstitial(ctx);
            _rewardVideo = new RewardVideo(ctx);
        } catch (e:Error) {
            trace(e.name);
            trace(e.message);
            trace(e.getStackTrace());
            trace(e.errorID);
            trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
        }
    }

    /**
     * This method is omitted from the output. * * @private
     */
    private function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case AdMobEvent.ON_REWARDED:
            case AdMobEvent.ON_CLICKED:
            case AdMobEvent.ON_LOADED:
            case AdMobEvent.ON_LOAD_FAILED:
            case AdMobEvent.ON_OPENED:
            case AdMobEvent.ON_CLOSED:
            case AdMobEvent.ON_IMPRESSION:
            case AdMobEvent.ON_LEFT_APPLICATION:
            case AdMobEvent.ON_VIDEO_STARTED:
                try {
                    //trace("event.code", event.code);
                    argsAsJSON = JSON.parse(event.code);
                    dispatchEvent(new AdMobEvent(event.level, argsAsJSON));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
        }
    }

    /**
     *
     * @param key - iOS only. This is your AdMob API key
     * @param volume - Sets the volume of Video Ads
     * @param muted - Sets whether Video Ads are muted
     * @param scaleFactor - Used on Android only
     * @return
     *
     */
    public function init(key:String, volume:Number = 1.0, muted:Boolean = false, scaleFactor:Number = 1.0):Boolean {
        var theRet:* = ctx.call("init", key, volume, muted, scaleFactor);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        _isInited = theRet as Boolean;
        return _isInited;
    }

    /**
     * This method is omitted from the output. * * @private
     */
    private function safetyCheck():Boolean {
        if (!_isInited) {
            trace("You need to init first");
            return false;
        }
        return _isSupported;
    }

    /**
     *
     * @return
     *
     */
    public function get banner():Banner {
        return _banner;
    }

    /**
     *
     * @return
     *
     */
    public function get interstitial():Interstitial {
        return _interstitial;
    }

    /**
     *
     * @return
     *
     */
    public function get rewardVideo():RewardVideo {
        return _rewardVideo;
    }

    /**
     *
     * @param value
     *
     */
    public function set testDevices(value:Vector.<String>):void {
        _testDevices = value;
        var theRet:* = ctx.call("setTestDevices", _testDevices);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /**
     *
     * @return
     *
     */
    public function get testDevices():Vector.<String> {
        return _testDevices;
    }

    /**
     *
     *
     */
    public function dispose():void {
        if (!ctx) {
            trace("[" + NAME + "] Error. ANE Already in a disposed or failed state...");
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        ctx.removeEventListener(StatusEvent.STATUS, gotEvent);
        ctx.dispose();
        ctx = null;
    }



}
}