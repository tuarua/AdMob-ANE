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

    /**
     * Initiates the request to fetch the reward based video ad. The |request| object supplies ad targeting
     * information and must not be null. The adUnit is the ad unit id used for fetching an ad and must not be nil.
     */
    public function load():void {
        var ret:* = _context.call("loadRewardVideo", _adUnit, _targeting, _showOnLoad);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Presents the reward based video ad.
     */
    public function show():void {
        var ret:* = _context.call("showRewardVideo");
        if (ret is ANEError) throw ret as ANEError;
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
