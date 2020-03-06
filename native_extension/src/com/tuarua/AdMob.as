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
package com.tuarua {
import com.tuarua.admob.Banner;
import com.tuarua.admob.Interstitial;
import com.tuarua.admob.RewardVideo;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;
import flash.external.ExtensionContext;

public class AdMob extends EventDispatcher {
    private var _testDevices:Vector.<String> = new <String>[];
    private var _banner:Banner = new Banner();
    private var _interstitial:Interstitial = new Interstitial();
    private var _rewardVideo:RewardVideo = new RewardVideo();
    private static var _disableSDKCrashReporting:Boolean;
    private static var _disableAutomatedInAppPurchaseReporting:Boolean;

    private static var _shared:AdMob;

    public function AdMob() {
        if (_shared) {
            throw new Error(AdMobANEContext.NAME + " is a singleton, use .shared()");
        }
        var tmp:ExtensionContext = AdMobANEContext.context;
        _shared = this;
    }

    public static function shared():AdMob {
        if (!_shared) new AdMob();
        return _shared;
    }

    /**
     *
     * @param volume - Sets the volume of Video Ads
     * @param muted - Sets whether Video Ads are muted
     * @param scaleFactor - Used on Android only
     * @param isPersonalised - Set based on user consent for GDPR
     *
     */
    public function init(volume:Number = 1.0, muted:Boolean = false, scaleFactor:Number = 1.0,
                         isPersonalised:Boolean = true):void {
        var ret:* = AdMobANEContext.context.call("init", volume, muted, scaleFactor, isPersonalised,
                _disableSDKCrashReporting ,_disableAutomatedInAppPurchaseReporting);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Resets consent information to default state and clears ad providers.
     */
    public function resetConsent():void {
        var ret:* = AdMobANEContext.context.call("resetConsent");
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
        var ret:* = AdMobANEContext.context.call("showConsentForm", privacyUrl,
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
        var ret:* = AdMobANEContext.context.call("requestConsentInfoUpdate", key);
        if (ret is ANEError) throw ret as ANEError;
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
        var ret:* = AdMobANEContext.context.call("setTestDevices", _testDevices);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get testDevices():Vector.<String> {
        return _testDevices;
    }

    /** If a publisher is aware that the user is under the age of consent,
     * all ad requests must set TFUA (Tag For Users under the Age of Consent in Europe). */
    public function get isTaggedForUnderAgeOfConsent():Boolean {
        var ret:* = AdMobANEContext.context.call("getIsTFUA");
        if (ret is ANEError) throw ret as ANEError;
        var _isTaggedForUnderAgeOfConsent:Boolean = ret as Boolean;
        return _isTaggedForUnderAgeOfConsent;
    }

    public function set isTaggedForUnderAgeOfConsent(value:Boolean):void {
        var ret:* = AdMobANEContext.context.call("setIsTFUA", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Debug geography. Used for debug devices only.*/
    public function set consentStatus(value:int):void {
        var ret:* = AdMobANEContext.context.call("setConsentStatus", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function set debugGeography(value:int):void {
        var ret:* = AdMobANEContext.context.call("setDebugGeography", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * <p>Disables automated SDK crash reporting. If not called, the SDK records the original exception handler if
     * available and registers a new exception handler. The new exception handler only reports SDK related exceptions
     * and calls the recorded original exception handler.</p>
     * <p><b>iOS only</b></p>
     * */
    public static function set disableSDKCrashReporting(value:Boolean):void {
        _disableSDKCrashReporting = value;
    }

    /**
     * <p>Disables automated in app purchase (IAP) reporting. Must be called before any IAP transaction is initiated.
     * IAP reporting is used to track IAP ad conversions. Do not disable reporting if you use IAP ads.</p>
     * <p><b>iOS only</b></p>
     * */
    public static function set disableAutomatedInAppPurchaseReporting(value:Boolean):void {
        _disableAutomatedInAppPurchaseReporting = value;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (AdMobANEContext.context) {
            AdMobANEContext.dispose();
        }
    }
}
}