package {
import com.tuarua.AdMobANE;
import com.tuarua.admobane.AdMobEvent;
import com.tuarua.admobane.AdSize;
import com.tuarua.admobane.Align;
import com.tuarua.admobane.Targeting;
import com.tuarua.fre.ANEError;
import com.tuarua.fre.ANEUtils;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.ResizeEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

import views.SimpleButton;

public class StarlingRoot extends Sprite {
    private var btn:SimpleButton = new SimpleButton("Load Banner", 100);
    private var btn2:SimpleButton = new SimpleButton("Clear Banner", 100);
    private var btn3:SimpleButton = new SimpleButton("Load InterS", 100);
    private var adMobANE:AdMobANE = new AdMobANE();

    public function StarlingRoot() {
    }

    public function start(assets:AssetManager):void {
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
        var _assets:AssetManager = assets;


        adMobANE.addEventListener(AdMobEvent.ON_CLICKED, onAdClicked);
        adMobANE.addEventListener(AdMobEvent.ON_CLOSED, onAdClosed);
        adMobANE.addEventListener(AdMobEvent.ON_IMPRESSION, onAdImpression);
        adMobANE.addEventListener(AdMobEvent.ON_LEFT_APPLICATION, onAdLeftApplication);
        adMobANE.addEventListener(AdMobEvent.ON_LOAD_FAILED, onAdLoadFailed);
        adMobANE.addEventListener(AdMobEvent.ON_LOADED, onAdLoaded);
        adMobANE.addEventListener(AdMobEvent.ON_OPENED, onAdOpened);
        adMobANE.init("ca-app-pub-3940256099942544~3347511713", 0.5, true);
        var vecDevices:Vector.<String> = new <String>[];
        vecDevices.push("09872C13E51671E053FC7DC8DFC0C689");
        adMobANE.testDevices = vecDevices;

        btn.x = 10;
        btn.y = 10;
        btn.addEventListener(TouchEvent.TOUCH, onLoadBanner);
        addChild(btn);

        btn2.x = 130;
        btn2.y = 10;
        btn2.addEventListener(TouchEvent.TOUCH, onClearBanner);
        addChild(btn2);

        btn3.x = 250;
        btn3.y = 10;
        btn3.addEventListener(TouchEvent.TOUCH, onLoadInterstitial);
        addChild(btn3);


        stage.addEventListener(Event.RESIZE, onResize);

    }

    private function onLoadInterstitial(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn3);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            try {
                var targeting:Targeting = new Targeting();
                targeting.birthday = new Date(1999, 5, 10);
                targeting.gender = Targeting.MALE;
                targeting.forChildren = true;
                adMobANE.interstitial.adUnit = "ca-app-pub-3940256099942544/1033173712";
                adMobANE.interstitial.targeting = targeting;
                adMobANE.interstitial.load();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }
        }
    }

    private static function onAdOpened(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
    }

    private static function onAdLoaded(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
    }

    private static function onAdLoadFailed(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
        var errorCode:int = event.params.errorCode;
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
                adMobANE.banner.clear();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }
        }
    }

    private function onLoadBanner(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            try {
                var targeting:Targeting = new Targeting();
                targeting.birthday = new Date(1999, 5, 10);
                targeting.gender = Targeting.MALE;
                targeting.forChildren = true;
                if (adMobANE.banner.canDisplay(AdSize.FULL_BANNER)) {
                    adMobANE.banner.adSize = AdSize.FULL_BANNER;
                } else if (adMobANE.banner.canDisplay(AdSize.SMART_BANNER)){
                    adMobANE.banner.adSize = AdSize.SMART_BANNER;
                } else {
                    adMobANE.banner.adSize = AdSize.BANNER;
                }

                adMobANE.banner.adUnit = "ca-app-pub-3940256099942544/6300978111";
                adMobANE.banner.targeting = targeting;
                adMobANE.banner.hAlign = Align.RIGHT;
                adMobANE.banner.vAlign = Align.BOTTOM;

                /*
                // x  & y supersede hAlign and vAlign if both > -1
                adMobANE.banner.x = 100;
                adMobANE.banner.y = 200;*/

                adMobANE.banner.load();

                trace("adMobANE.banner.availableSizes:", adMobANE.banner.availableSizes);
                trace(adMobANE.banner.canDisplay(AdSize.FULL_BANNER))


            } catch (e:ANEError) {
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
        adMobANE.banner.adUnit = "ca-app-pub-3940256099942544/6300978111";
        if (current.viewPort.width > current.viewPort.height) {
            adMobANE.banner.adSize = AdSize.LEADERBOARD;
            adMobANE.banner.load();
        } else {
            adMobANE.banner.adSize = AdSize.MEDIUM_RECTANGLE;
            adMobANE.banner.load();
        }


    }

    /**
     * It's very important to call adMobANE.dispose(); when the app is exiting.
     */
    private function onExiting(event:Event):void {
        adMobANE.dispose();
    }
}
}



