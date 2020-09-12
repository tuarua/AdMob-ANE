package {
import com.tuarua.AdMob;
import com.tuarua.admob.AdMobEvent;
import com.tuarua.admob.AdSize;
import com.tuarua.admob.Align;
import com.tuarua.admob.MaxAdContentRating;
import com.tuarua.admob.Targeting;
import com.tuarua.fre.ANEError;
import com.tuarua.ump.ConsentDebugGeography;
import com.tuarua.ump.ConsentDebugSettings;
import com.tuarua.ump.ConsentFormStatus;
import com.tuarua.ump.ConsentInformation;
import com.tuarua.ump.ConsentRequestParameters;
import com.tuarua.ump.ConsentStatus;
import com.tuarua.ump.ConsentType;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.ResizeEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import utils.os;

import views.SimpleButton;

//noinspection JSMethodCanBeStatic
public class StarlingRoot extends Sprite {
    private static const GAP:int = 70;
    private var btn1:SimpleButton = new SimpleButton("Load Banner");
    private var btn2:SimpleButton = new SimpleButton("Clear Banner");
    private var btn3:SimpleButton = new SimpleButton("Load Interstitial");
    private var btn4:SimpleButton = new SimpleButton("Load Reward");
    private var btn5:SimpleButton = new SimpleButton("Reset Consent");
    private var adMob:AdMob;
    private var consentInformation:ConsentInformation;

    public function StarlingRoot() {
    }

    public function start():void {
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);

        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        // on iOS to retrieve your deviceID run: adt -devices -platform iOS
        adMob = AdMob.shared();
        adMob.addEventListener(AdMobEvent.ON_CLICKED, onAdClicked);
        adMob.addEventListener(AdMobEvent.ON_CLOSED, onAdClosed);
        adMob.addEventListener(AdMobEvent.ON_IMPRESSION, onAdImpression);
        adMob.addEventListener(AdMobEvent.ON_LEFT_APPLICATION, onAdLeftApplication);
        adMob.addEventListener(AdMobEvent.ON_LOAD_FAILED, onAdLoadFailed);
        adMob.addEventListener(AdMobEvent.ON_LOADED, onAdLoaded);
        adMob.addEventListener(AdMobEvent.ON_OPENED, onAdOpened);
        adMob.addEventListener(AdMobEvent.ON_VIDEO_STARTED, onVideoStarted);
        adMob.addEventListener(AdMobEvent.ON_VIDEO_COMPLETE, onVideoComplete);
        adMob.addEventListener(AdMobEvent.ON_REWARDED, onRewarded);

        consentInformation = ConsentInformation.shared();

        // In real app we don't reset everytime. This is for testing development.
        consentInformation.reset();
        var parameters:ConsentRequestParameters = new ConsentRequestParameters();
        parameters.tagForUnderAgeOfConsent = false;
        var debugSettings:ConsentDebugSettings = new ConsentDebugSettings();
        debugSettings.geography = ConsentDebugGeography.notEEA;
        parameters.appId = "ca-app-pub-6662565384314504~8614994766";

        // on iOS to retrieve your deviceID run: adt -devices -platform iOS
        debugSettings.testDeviceIdentifiers.push("459d71e2266bab6c3b7702ab5fe011e881b90d3c");
        parameters.debugSettings = debugSettings;
        consentInformation.requestConsentInfoUpdate(parameters, function (error:Error):void {
            if (error != null) {
                trace("requestConsentInfoUpdate error:", error.message);
                initAdMob(false);
                return;
            }
            handleConsentUpdate();
        })
    }

    private function handleConsentUpdate():void {
        trace("consentInformation.consentType: ", consentInformation.consentType);

        switch (consentInformation.consentStatus) {
            case ConsentStatus.unknown:
                trace("ConsentStatus.unknown");
                return;
            case ConsentStatus.obtained:
                trace("User consent obtained. Personalization not defined.");
                initAdMob(consentInformation.consentType == ConsentType.personalized, true);
                break;
            case ConsentStatus.required:
                trace("User consent required but not yet obtained.");
                showConsentForm();
                break;
            case ConsentStatus.notRequired:
                trace("User consent not required. For example, the user is not in the EEA or UK.");
                initAdMob(true, false);
                break;
        }
    }

    private function initMenu(inEU:Boolean):void {
        btn1.x = btn2.x = btn3.x = btn4.x = btn5.x = (stage.stageWidth - 200) * 0.5;
        btn1.y = GAP;
        btn2.y = btn1.y + GAP;
        btn3.y = btn2.y + GAP;
        btn4.y = btn3.y + GAP;
        btn5.y = btn4.y + GAP;

        btn1.addEventListener(TouchEvent.TOUCH, onLoadBanner);
        btn2.addEventListener(TouchEvent.TOUCH, onClearBanner);
        btn3.addEventListener(TouchEvent.TOUCH, onLoadInterstitial);
        btn4.addEventListener(TouchEvent.TOUCH, onLoadReward);

        addChild(btn1);
        addChild(btn2);
        addChild(btn3);
        addChild(btn4);

        if (inEU) {
            btn5.addEventListener(TouchEvent.TOUCH, onResetConsent);
            addChild(btn5);
        }

        stage.addEventListener(Event.RESIZE, onResize);
    }

    private function showConsentForm():void {
        if (consentInformation.formStatus === ConsentFormStatus.available) {
            consentInformation.showConsentForm(function (error:Error):void {
                if (error != null) {
                    trace("showConsentForm error:", error.message);
                    initAdMob(false);
                    return;
                }
                handleConsentUpdate();
            });
        }
    }

    private function initAdMob(personalized:Boolean, inEU:Boolean = false):void {
        adMob.init(0.5, true, Starling.current.contentScaleFactor, personalized);
        initMenu(inEU);
    }

    private function onVideoStarted(event:AdMobEvent):void {
        trace(event);
    }

    private function onVideoComplete(event:AdMobEvent):void {
        trace(event);
    }

    private function onRewarded(event:AdMobEvent):void {
        trace(event);
        trace("Reward=", event.params.amount, event.params.type);
    }

    private function onLoadInterstitial(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn3);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            try {
                var targeting:Targeting = new Targeting();
                targeting.tagForChildDirectedTreatment = false;

                adMob.interstitial.adUnit = "ca-app-pub-3940256099942544/1033173712";
                adMob.interstitial.targeting = targeting;
                adMob.interstitial.load();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }
        }
    }

    private function onLoadReward(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn4);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            try {
                var targeting:Targeting = new Targeting();
                targeting.tagForChildDirectedTreatment = false;

                adMob.rewardVideo.adUnit = os.isIos ? "ca-app-pub-3940256099942544/1712485313" : "ca-app-pub-3940256099942544/5224354917";
                adMob.rewardVideo.targeting = targeting;
                adMob.rewardVideo.load();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }
        }
    }

    private function onResetConsent(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn5);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            consentInformation.reset();
        }
    }

    private static function onAdOpened(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
    }

    private static function onAdLoaded(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
        trace("position", position);
    }

    private static function onAdLoadFailed(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
        var errorCode:int = event.params.errorCode;

        trace("Ad failed to load", position, errorCode);

    }

    private static function onAdLeftApplication(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
    }

    private static function onAdImpression(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
    }

    private static function onAdClosed(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
    }

    private static function onAdClicked(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
    }

    private function onClearBanner(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn2);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            try {
                trace("calling adMob.banner.clear()");
                adMob.banner.clear();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }
        }
    }

    private function onLoadBanner(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn1);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            try {
                var targeting:Targeting = new Targeting();
                targeting.tagForChildDirectedTreatment = true;
                targeting.maxAdContentRating = MaxAdContentRating.PARENTAL_GUIDANCE;
                targeting.contentUrl = "http://googleadsdeveloper.blogspot.com/2016/03/rewarded-video-support-for-admob.html";

                trace("adMob.banner.availableSizes:", adMob.banner.availableSizes);
                trace("Can we display a smart banner? ", adMob.banner.canDisplay(AdSize.FULL_BANNER));

                if (adMob.banner.canDisplay(AdSize.FULL_BANNER)) {
                    adMob.banner.adSize = AdSize.FULL_BANNER;
                } else if (adMob.banner.canDisplay(AdSize.SMART_BANNER)) {
                    adMob.banner.adSize = AdSize.SMART_BANNER;
                } else {
                    adMob.banner.adSize = AdSize.BANNER;
                }

                adMob.banner.adUnit = "ca-app-pub-3940256099942544/6300978111";
                adMob.banner.targeting = targeting;
                adMob.banner.hAlign = Align.RIGHT;
                adMob.banner.vAlign = Align.BOTTOM;


                // x  & y supersede hAlign and vAlign if both > -1
                /*adMob.banner.x = 40;
                adMob.banner.y = 50;*/

                adMob.banner.load();


            } catch (e:ANEError) {
                trace(e.name);
                trace(e.errorID);
                trace(e.type);
                trace(e.message);
                trace(e.source);
                trace(e.getStackTrace());
            }
        }
    }


    public function onResize(event:ResizeEvent):void {

        var current:Starling = Starling.current;
        var scale:Number = current.contentScaleFactor;

        stage.stageWidth = event.width / scale;
        stage.stageHeight = event.height / scale;

        current.viewPort.width = stage.stageWidth * scale;
        current.viewPort.height = stage.stageHeight * scale;

        trace(current.viewPort);

        //when we rotate the device we demo switching different sizes
        /*adMob.banner.adUnit = "ca-app-pub-3940256099942544/6300978111";
        if (current.viewPort.width > current.viewPort.height) {
            adMob.banner.adSize = AdSize.LEADERBOARD;
            adMob.banner.load();
        } else {
            adMob.banner.adSize = AdSize.MEDIUM_RECTANGLE;
            adMob.banner.load();
        }*/


    }

    /**
     * It's very important to call adMob.dispose(); when the app is exiting.
     */
    private function onExiting(event:Event):void {
        AdMob.dispose();
    }
}
}



