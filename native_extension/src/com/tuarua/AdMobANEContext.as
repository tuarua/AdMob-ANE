package com.tuarua {
import com.tuarua.admob.AdMobEvent;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;
/** @private */
public class AdMobANEContext {
    internal static const NAME:String = "AdMobANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;
    public static var callbacks:Dictionary = new Dictionary();
    private static var argsAsJSON:Object;
    public function AdMobANEContext() {
    }
    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
            } catch (e:Error) {
                throw new Error("ANE " + NAME + " not created properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    public static function createCallback(listener:Function):String {
        var id:String;
        if (listener) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    public static function callCallback(callbackId:String, clear:Boolean = true, ... args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        if (clear) {
            delete callbacks[callbackId];
        }
    }

    private static function gotEvent(event:StatusEvent):void {
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
                    AdMob.shared().dispatchEvent(new AdMobEvent(event.level, argsAsJSON));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
        }
    }

    public static function dispose():void {
        if (!_context) return;
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }
}
}
