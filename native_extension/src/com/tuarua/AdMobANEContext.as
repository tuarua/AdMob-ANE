package com.tuarua {
import com.tuarua.admob.AdMobEvent;
import com.tuarua.ump.ConsentInformation;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;
/** @private */
public class AdMobANEContext {
    internal static const NAME:String = "AdMobANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;
    public static var callbacks:Dictionary = new Dictionary();
    public static var callbackCallers:Dictionary = new Dictionary();
    private static var argsAsJSON:Object;

    private static const ON_CONSENT_INFO_UPDATE:String = "AdMob.onConsentInfoUpdate";
    private static const ON_CONSENT_FORM_DISMISSED:String = "AdMob.onConsentFormDismissed";

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

    public static function createCallback(listener:Function, listenerCaller:Object = null):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
            if (listenerCaller) {
                callbackCallers[id] = listenerCaller;
            }
        }
        return id;
    }

    public static function callCallback(callbackId:String, clear:Boolean, ... args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        if (clear) {
            delete callbacks[callbackId];
            delete callbackCallers[callbackId];
        }
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:Error;
        var callbackCaller:*;
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
                try {
                    argsAsJSON = JSON.parse(event.code);
                    AdMob.shared().dispatchEvent(new AdMobEvent(event.level, argsAsJSON));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case ON_CONSENT_INFO_UPDATE:
            case ON_CONSENT_FORM_DISMISSED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    callbackCaller = callbackCallers[argsAsJSON.callbackId];
                    if (callbackCaller == null) return;

                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new Error(argsAsJSON.error.text, argsAsJSON.error.id);
                    } else if (argsAsJSON.hasOwnProperty("data")
                            && argsAsJSON.data) {
                        var consentInformation:ConsentInformation = callbackCaller as ConsentInformation;
                        consentInformation.formStatus = argsAsJSON.data["formStatus"];
                        consentInformation.consentStatus = argsAsJSON.data["consentStatus"];
                        consentInformation.consentType = argsAsJSON.data["consentType"];
                    }
                    callCallback(argsAsJSON.callbackId, true, err);
                } catch (e:Error) {
                    trace(e.message);
                    trace(e.getStackTrace());
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
