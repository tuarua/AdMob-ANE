package com.tuarua.admobane {
import com.tuarua.fre.ANEError;

import flash.external.ExtensionContext;

public class Banner {
    private var _context:ExtensionContext;
    private var _adUnit:String = "ca-app-pub-3940256099942544/6300978111";
    private var _adSize:int = AdSize.BANNER;
    private var _availableSizes:Vector.<int> = new Vector.<int>();
    private var _targeting:Targeting;
    private var _x:Number = -1;
    private var _y:Number = -1;
    private var _hAlign:String = Align.CENTER;
    private var _vAlign:String = Align.BOTTOM;

    public function Banner(context:ExtensionContext) {
        this._context = context;
    }
	/**
	 * Load the banner
	 */
    public function load():void {
        var ret:* = _context.call("loadBanner", _adUnit, _adSize, _targeting, _x, _y, _hAlign, _vAlign);
        if (ret is ANEError) throw ret as ANEError;
    }
	/**
	 * Clear the banner
	 */
    public function clear():void {
        var ret:* = _context.call("clearBanner");
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Example AdMob ad unit ID: "ca-app-pub-0123456789012345/0123456789" */
    public function get adUnit():String {
        return _adUnit;
    }

    public function set adUnit(value:String):void {
        _adUnit = value;
    }

    public function get adSize():int {
        return _adSize;
    }

    public function set adSize(value:int):void {
        _adSize = value;
    }

    public function get availableSizes():Vector.<int> {
        if (_availableSizes.length == 0) {
            var ret:* = _context.call("getBannerSizes");
            if (ret is ANEError) throw ret as ANEError;
            _availableSizes = ret as Vector.<int> ;
        }
        return _availableSizes
    }

    public function canDisplay(size:int):Boolean {
        return availableSizes.indexOf(size) > -1
    }

    public function get targeting():Targeting {
        return _targeting;
    }

    public function set targeting(value:Targeting):void {
        _targeting = value;
    }

    public function set x(value:int):void {
        _x = value;
    }

    public function set y(value:int):void {
        _y = value;
    }

    public function set hAlign(value:String):void {
        _hAlign = value;
    }

    public function set vAlign(value:String):void {
        _vAlign = value;
    }
}
}
