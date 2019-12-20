package com.tuarua.admobane {
public final class Targeting {
    public var contentUrl:String;
    private var _forChildren:Boolean = false;
    /** @private */
    public var forChildrenSet:Boolean = false;
    public function get forChildren():Boolean {
        return _forChildren;
    }
    /** @deprecated */
    public function set forChildren(value:Boolean):void {
        forChildrenSet = true;
        _forChildren = value;
    }
}
}
