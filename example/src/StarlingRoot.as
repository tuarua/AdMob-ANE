package {
import com.tuarua.AdMobANE;
import com.tuarua.admobane.AdMobEvent;
import com.tuarua.admobane.AdSize;
import com.tuarua.admobane.Align;
import com.tuarua.admobane.ConsentStatus;
import com.tuarua.admobane.DebugGeography;
import com.tuarua.admobane.MaxAdContentRating;
import com.tuarua.admobane.Targeting;
import com.tuarua.fre.ANEError;

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

public class StarlingRoot extends Sprite {
    private static const GAP:int = 70;
    private var btn1:SimpleButton = new SimpleButton("Load Banner");
    private var btn2:SimpleButton = new SimpleButton("Clear Banner");
    private var btn3:SimpleButton = new SimpleButton("Load Interstitial");
    private var btn4:SimpleButton = new SimpleButton("Load Reward");
    private var btn5:SimpleButton = new SimpleButton("Reset Consent");
    private var adMobANE:AdMobANE = new AdMobANE();

    public function StarlingRoot() {
    }

    public function start():void {
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);

        //// Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        //on iOS to retrieve your deviceID run: adt -devices -platform iOS

        adMobANE.addEventListener(AdMobEvent.ON_CLICKED, onAdClicked);
        adMobANE.addEventListener(AdMobEvent.ON_CLOSED, onAdClosed);
        adMobANE.addEventListener(AdMobEvent.ON_IMPRESSION, onAdImpression);
        adMobANE.addEventListener(AdMobEvent.ON_LEFT_APPLICATION, onAdLeftApplication);
        adMobANE.addEventListener(AdMobEvent.ON_LOAD_FAILED, onAdLoadFailed);
        adMobANE.addEventListener(AdMobEvent.ON_LOADED, onAdLoaded);
        adMobANE.addEventListener(AdMobEvent.ON_OPENED, onAdOpened);
        adMobANE.addEventListener(AdMobEvent.ON_VIDEO_STARTED, onVideoStarted);
        adMobANE.addEventListener(AdMobEvent.ON_VIDEO_COMPLETE, onVideoComplete);
        adMobANE.addEventListener(AdMobEvent.ON_REWARDED, onRewarded);
        adMobANE.addEventListener(AdMobEvent.ON_CONSENT_INFO_UPDATE, onConsentInfoUpdate);
        adMobANE.addEventListener(AdMobEvent.ON_CONSENT_FORM_DISMISSED, onConsentFormDismissed);

        initAdMob(true);
        return;
//        adMobANE.isTaggedForUnderAgeOfConsent = true;
//        adMobANE.debugGeography = DebugGeography.EEA;
//        adMobANE.requestConsentInfoUpdate(new <String>["pub-YOUR_ID"]);
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

    private function onConsentInfoUpdate(event:AdMobEvent):void {
        if (event.params.isRequestLocationInEEAOrUnknown) {
            // in EU, ask whether user wishes to receive personalised Ads
            switch (event.params.consentStatus) {
                case ConsentStatus.UNKNOWN:
                    // launch consent form
                    showConsentForm();
                    return;
                case ConsentStatus.PERSONALIZED:
                    // user has agreed prior
                    initAdMob(true, true);
                    break;
                case ConsentStatus.NON_PERSONALIZED:
                    // boo user said no
                    initAdMob(false, true);
                    break;
            }
        } else {
            // outside EU
            initAdMob(true);
        }

    }

    private function onConsentFormDismissed(event:AdMobEvent):void {
        initAdMob(event.params.consentStatus == ConsentStatus.PERSONALIZED, true);
    }

    private function showConsentForm():void {
        adMobANE.showConsentForm("https://media.termsfeed.com/pdf/privacy-policy-template.pdf");
    }

    private function initAdMob(isPersonalised:Boolean, inEU:Boolean = false):void {
        adMobANE.init(0.5, true, Starling.current.contentScaleFactor, isPersonalised);
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

                adMobANE.interstitial.adUnit = "ca-app-pub-3940256099942544/1033173712";
                adMobANE.interstitial.targeting = targeting;
                adMobANE.interstitial.load();
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

                adMobANE.rewardVideo.adUnit = os.isIos ? "ca-app-pub-3940256099942544/1712485313" : "ca-app-pub-3940256099942544/5224354917";
                adMobANE.rewardVideo.targeting = targeting;
                adMobANE.rewardVideo.load();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }
        }
    }

    private function onResetConsent(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn5);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            adMobANE.resetConsent();
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
                trace("calling adMobANE.banner.clear()");
                adMobANE.banner.clear();
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

                trace("adMobANE.banner.availableSizes:", adMobANE.banner.availableSizes);
                trace("Can we display a smart banner? ", adMobANE.banner.canDisplay(AdSize.FULL_BANNER));

                if (adMobANE.banner.canDisplay(AdSize.FULL_BANNER)) {
                    adMobANE.banner.adSize = AdSize.FULL_BANNER;
                } else if (adMobANE.banner.canDisplay(AdSize.SMART_BANNER)) {
                    adMobANE.banner.adSize = AdSize.SMART_BANNER;
                } else {
                    adMobANE.banner.adSize = AdSize.BANNER;
                }

                adMobANE.banner.adUnit = "ca-app-pub-3940256099942544/6300978111";
                adMobANE.banner.targeting = targeting;
                adMobANE.banner.hAlign = Align.RIGHT;
                adMobANE.banner.vAlign = Align.BOTTOM;


                // x  & y supersede hAlign and vAlign if both > -1
                /*adMobANE.banner.x = 40;
                adMobANE.banner.y = 50;*/

                adMobANE.banner.load();


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
        /*adMobANE.banner.adUnit = "ca-app-pub-3940256099942544/6300978111";
        if (current.viewPort.width > current.viewPort.height) {
            adMobANE.banner.adSize = AdSize.LEADERBOARD;
            adMobANE.banner.load();
        } else {
            adMobANE.banner.adSize = AdSize.MEDIUM_RECTANGLE;
            adMobANE.banner.load();
        }*/


    }

    /**
     * It's very important to call adMobANE.dispose(); when the app is exiting.
     */
    private function onExiting(event:Event):void {
        adMobANE.dispose();
    }
}
}



