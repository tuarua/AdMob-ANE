package com.tuarua.admobane {
public class Targeting extends Object {
    public var contentUrl:String;
    private var _forChildren:Boolean = false;
    public var forChildrenSet:Boolean = false;
	/**
	 * 
	 * @return 
	 * 
	 */
    public function get forChildren():Boolean {
        return _forChildren;
    }
	/**
	 * 
	 * @param value
	 * 
	 */
    public function set forChildren(value:Boolean):void {
        forChildrenSet = true;
        _forChildren = value;
    }
}
}
