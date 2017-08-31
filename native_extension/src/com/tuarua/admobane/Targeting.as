package com.tuarua.admobane {
public class Targeting extends Object {
    public static const UNSPECIFIED:int = 0;
    public static const MALE:int = 1;
    public static const FEMALE:int = 2;
    public var birthday:Date;
    public var gender:int = UNSPECIFIED;
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
