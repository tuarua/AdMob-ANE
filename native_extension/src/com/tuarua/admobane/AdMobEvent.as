package com.tuarua.admobane {
import flash.events.Event;

public class AdMobEvent extends Event{
    public static const ON_LOADED:String = "AdMob.OnLoaded";
    public static const ON_LOAD_FAILED:String = "AdMob.OnLoadFailed";
    public static const ON_OPENED:String = "AdMob.OnOpened";
    public static const ON_CLOSED:String = "AdMob.OnClosed";
    public static const ON_CLICKED:String = "AdMob.OnClicked";
    public static const ON_IMPRESSION:String = "AdMob.OnImpression";
    public static const ON_LEFT_APPLICATION:String = "AdMob.OnLeftApplication";
    public static const ON_REWARDED:String = "AdMob.onRewarded";
    public static const ON_VIDEO_STARTED:String = "AdMob.onVideoStarted";
    public static const ON_VIDEO_COMPLETE:String = "AdMob.onVideoComplete";

    public var params:*;
    public function AdMobEvent(type:String, params:* = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.params = params;
    }

    public override function clone():Event {
        return new AdMobEvent(type, this.params, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("AdMobEvent", "params", "type", "bubbles", "cancelable");
    }
}
}
