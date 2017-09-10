package com.tuarua.admobane {
import com.tuarua.fre.ANEError;

import flash.external.ExtensionContext;

public class Banner {
    private var _context:ExtensionContext;
    private var _adUnit:String = "ca-app-pub-3940256099942544/6300978111";
    private var _adSize:int = AdSize.BANNER;
    private var _availableSizes:Array = [];
    private var _targeting:Targeting;
    private var _x:Number = -1;
    private var _y:Number = -1;
    private var _hAlign:String = Align.CENTER;
    private var _vAlign:String = Align.BOTTOM;

    public function Banner(context:ExtensionContext) {
        this._context = context;
    }
	/**
	 * 
	 * Load the banner
	 */
    public function load():void {
        var theRet:* = _context.call("loadBanner", _adUnit, _adSize, _targeting, _x, _y, _hAlign, _vAlign);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }
	/**
	 * 
	 * Clear the banner
	 */
    public function clear():void {
        var theRet:* = _context.call("clearBanner");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
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
	 * @return 
	 * 
	 */
    public function get adSize():int {
        return _adSize;
    }
	/**
	 * 
	 * @param value
	 * 
	 */
    public function set adSize(value:int):void {
        _adSize = value;
    }
	/**
	 * 
	 * @return 
	 * 
	 */
    public function get availableSizes():Array {
        if (_availableSizes.length == 0) {
            var theRet:* = _context.call("getBannerSizes");
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
            _availableSizes = theRet as Array;
        }
        return _availableSizes
    }
	/**
	 * 
	 * @param size
	 * @return 
	 * 
	 */
    public function canDisplay(size:int):Boolean {
        return availableSizes.indexOf(size) > -1
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
	 * @param value
	 * 
	 */
    public function set x(value:int):void {
        _x = value;
    }
	/**
	 * 
	 * @param value
	 * 
	 */
    public function set y(value:int):void {
        _y = value;
    }
	/**
	 * 
	 * @param value
	 * 
	 */
    public function set hAlign(value:String):void {
        _hAlign = value;
    }
	/**
	 * 
	 * @param value
	 * 
	 */
    public function set vAlign(value:String):void {
        _vAlign = value;
    }
}
}
