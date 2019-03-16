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

    /** @private */
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

    /** @private */
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
            case AdMobEvent.ON_VIDEO_COMPLETE:
            case AdMobEvent.ON_CONSENT_INFO_UPDATE:
            case AdMobEvent.ON_CONSENT_FORM_DISMISSED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    dispatchEvent(new AdMobEvent(event.level, argsAsJSON));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
        }
    }


    /**
     * Resets consent information to default state and clears ad providers.
     */
    public function resetConsent():void {
        var ret:* = ctx.call("resetConsent");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Presents the full screen consent form above AIR stage.
     *
     * @param privacyUrl
     * @param shouldOfferPersonalizedAds Indicates whether the consent form should show a personalized ad option. Defaults to true.
     * @param shouldOfferNonPersonalizedAds Indicates whether the consent form should show a non-personalized ad option. Defaults to true.
     * @param shouldOfferAdFree Indicates whether the consent form should show an ad-free app option. Defaults to false.
     */
    public function showConsentForm(privacyUrl:String,
                                    shouldOfferPersonalizedAds:Boolean = true,
                                    shouldOfferNonPersonalizedAds:Boolean = true,
                                    shouldOfferAdFree:Boolean = false):void {
        var ret:* = ctx.call("showConsentForm", privacyUrl,
                shouldOfferPersonalizedAds,
                shouldOfferNonPersonalizedAds,
                shouldOfferAdFree);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Requests consent information update for the provided publisher identifiers. All publisher
     * identifiers used in the application should be specified in this call. Consent status is reset to
     * unknown when the ad provider list changes.
     * @param key -
     *
     */
    public function requestConsentInfoUpdate(key:Vector.<String>):void {
        var ret:* = ctx.call("requestConsentInfoUpdate", key);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     *
     * @param key - iOS only. This is your AdMob API key
     * @param volume - Sets the volume of Video Ads
     * @param muted - Sets whether Video Ads are muted
     * @param scaleFactor - Used on Android only
     * @param isPersonalised - Set based on user consent for GDPR
     * @return
     *
     */
    public function init(key:String, volume:Number = 1.0, muted:Boolean = false, scaleFactor:Number = 1.0,
                         isPersonalised:Boolean = true):Boolean {
        var ret:* = ctx.call("init", key, volume, muted, scaleFactor, isPersonalised);
        if (ret is ANEError) throw ret as ANEError;
        _isInited = ret as Boolean;
        return _isInited;
    }

    public function get banner():Banner {
        return _banner;
    }

    public function get interstitial():Interstitial {
        return _interstitial;
    }

    public function get rewardVideo():RewardVideo {
        return _rewardVideo;
    }

    /** Test ads will be returned for devices with device IDs specified in this array. */
    public function set testDevices(value:Vector.<String>):void {
        _testDevices = value;
        var ret:* = ctx.call("setTestDevices", _testDevices);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get testDevices():Vector.<String> {
        return _testDevices;
    }

    /** disposes the ANE*/
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

    /** If a publisher is aware that the user is under the age of consent,
     * all ad requests must set TFUA (Tag For Users under the Age of Consent in Europe). */
    public function get isTaggedForUnderAgeOfConsent():Boolean {
        var ret:* = ctx.call("getIsTFUA");
        if (ret is ANEError) throw ret as ANEError;
        var _isTaggedForUnderAgeOfConsent:Boolean = ret as Boolean;
        return _isTaggedForUnderAgeOfConsent;
    }

    public function set isTaggedForUnderAgeOfConsent(value:Boolean):void {
        var ret:* = ctx.call("setIsTFUA", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Debug geography. Used for debug devices only.*/
    public function set consentStatus(value:int):void {
        var ret:* = ctx.call("setConsentStatus", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function set debugGeography(value:int):void {
        var ret:* = ctx.call("setDebugGeography", value);
        if (ret is ANEError) throw ret as ANEError;
    }
}
}