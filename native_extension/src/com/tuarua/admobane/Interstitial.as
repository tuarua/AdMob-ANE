package com.tuarua.admobane {
import com.tuarua.fre.ANEError;

import flash.external.ExtensionContext;

public class Interstitial {
    private var _context:ExtensionContext;
    private var _adUnit:String = "ca-app-pub-3940256099942544/1033173712";
    private var _targeting:Targeting;
    private var _showOnLoad:Boolean = true;
    public function Interstitial(context:ExtensionContext) {
        this._context = context;
    }
	/**
	 * Makes an interstitial ad request. Additional targeting options can be supplied with a request object.
     * Only one interstitial request is allowed at a time.
	 */
    public function load():void {
        var ret:* = _context.call("loadInterstitial", _adUnit, _targeting, _showOnLoad);
        if (ret is ANEError) throw ret as ANEError;
    }

	/**
	 * Presents the interstitial ad which takes over the entire screen until the user dismisses it.
     * This has no effect unless isReady returns true and/or the delegate's interstitialDidReceiveAd: has been received.
	 */
    public function show():void {
        var ret:* = _context.call("showInterstitial");
        if (ret is ANEError) throw ret as ANEError;
    }
	/**
	 * 
	 * @return 
	 * 
	 */
    public function get targeting():Targeting {
        return _targeting;
    }
	/**
	 * 
	 * @param value
	 * 
	 */
    public function set targeting(value:Targeting):void {
        _targeting = value;
    }
	/**
	 * 
	 * @return 
	 * 
	 */
    public function get adUnit():String {
        return _adUnit;
    }
	/**
	 * 
	 * @param value
	 * 
	 */
    public function set adUnit(value:String):void {
        _adUnit = value;
    }
	/**
	 * 
	 * @param value
	 * 
	 */
    public function set showOnLoad(value:Boolean):void {
        _showOnLoad = value;
    }
}
}
