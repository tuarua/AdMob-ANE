/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.admob {
public final class Targeting {
    public var contentUrl:String;
    private var _tagForChildDirectedTreatment:Boolean;
    private var _tagForUnderAgeOfConsent:Boolean;
    private var _maxAdContentRating:String = MaxAdContentRating.GENERAL;
    /** @private */
    private var _tagForChildDirectedTreatmentSet:Boolean = false;
    /** @private */
    private var _tagForUnderAgeOfConsentSet:Boolean = false;

    public function set tagForChildDirectedTreatment(value:Boolean):void {
        _tagForChildDirectedTreatmentSet = true;
        _tagForChildDirectedTreatment = value;
    }

    public function get tagForChildDirectedTreatment():Boolean {
        return _tagForChildDirectedTreatment;
    }

    public function get tagForUnderAgeOfConsent():Boolean {
        return _tagForUnderAgeOfConsent;
    }

    public function set tagForUnderAgeOfConsent(value:Boolean):void {
        _tagForUnderAgeOfConsentSet = true;
        _tagForUnderAgeOfConsent = value;
    }

    public function get maxAdContentRating():String {
        return _maxAdContentRating;
    }

    public function set maxAdContentRating(value:String):void {
        _maxAdContentRating = value;
    }

    public function get tagForChildDirectedTreatmentSet():Boolean {
        return _tagForChildDirectedTreatmentSet;
    }

    public function get tagForUnderAgeOfConsentSet():Boolean {
        return _tagForUnderAgeOfConsentSet;
    }
}
}
