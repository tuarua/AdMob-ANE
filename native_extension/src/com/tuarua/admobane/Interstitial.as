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
	 * 
	 * 
	 */
    public function load():void {
        var theRet:* = _context.call("loadInterstitial", _adUnit, _targeting, _showOnLoad);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }
	/**
	 * 
	 * 
	 */
    public function clear():void {
        var theRet:* = _context.call("clearInterstitial");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }
	/**
	 * 
	 * 
	 */
    public function show():void {
        var theRet:* = _context.call("showInterstitial");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
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
