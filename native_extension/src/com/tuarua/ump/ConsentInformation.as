/*
 *  Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.ump {
import com.tuarua.AdMobANEContext;
import com.tuarua.fre.ANEError;

public class ConsentInformation {
    /** The user's consent status. This value is cached between app sessions and
     * can be read before requesting updated parameters. */
    public var consentStatus:uint;
    /** The user's consent type. This value is cached between app sessions and can be read before
     * requesting updated parameters. */
    public var consentType:uint;
    /** Consent form status. This value defaults to ConsentFormStatus.unknown and requires a call to
     * requestConsentInfoUpdate() to update. */
    public var formStatus:uint;
    private static var _shared:ConsentInformation;

    public function ConsentInformation() {
        if (_shared) {
            throw new Error("ConsentInformation is a singleton, use .shared()");
        }
        _shared = this;
    }

    public static function shared():ConsentInformation {
        if (!_shared) new ConsentInformation();
        return _shared;
    }

    public function requestConsentInfoUpdate(parameters:ConsentRequestParameters, listener:Function):void {
        var ret:* = AdMobANEContext.context.call("requestConsentInfoUpdate", parameters,
                AdMobANEContext.createCallback(listener, this));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function reset():void {
        var ret:* = AdMobANEContext.context.call("resetConsent");
        if (ret is ANEError) throw ret as ANEError;
    }

    public function showConsentForm(listener:Function):void {
        var ret:* = AdMobANEContext.context.call("showConsentForm", AdMobANEContext.createCallback(listener, this));
        if (ret is ANEError) throw ret as ANEError;
    }

}
}
