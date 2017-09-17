package com.tuarua.admobane {
import com.tuarua.fre.ANEError;

import flash.external.ExtensionContext;

public class RewardVideo {
    private var _context:ExtensionContext;
    private var _adUnit:String = "ca-app-pub-3940256099942544/1712485313";
    private var _targeting:Targeting;
    private var _showOnLoad:Boolean = true;

    public function RewardVideo(context:ExtensionContext) {
        this._context = context;
    }

    public function load():void {
        var theRet:* = _context.call("loadRewardVideo", _adUnit, _targeting, _showOnLoad);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function show():void {
        var theRet:* = _context.call("showRewardVideo");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function get adUnit():String {
        return _adUnit;
    }

    public function set adUnit(value:String):void {
        _adUnit = value;
    }

    public function get targeting():Targeting {
        return _targeting;
    }

    public function set targeting(value:Targeting):void {
        _targeting = value;
    }

    public function set showOnLoad(value:Boolean):void {
        _showOnLoad = value;
    }
}
}
