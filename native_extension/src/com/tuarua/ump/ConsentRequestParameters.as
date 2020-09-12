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
/** Parameters sent on updates to user consent info. */
public class ConsentRequestParameters {
    /** Indicates whether the user is tagged for under age of consent. */
    public var tagForUnderAgeOfConsent:Boolean;
    /** Debug settings for the request. */
    public var debugSettings:ConsentDebugSettings;

    public var appId:String;

    public function ConsentRequestParameters() {
    }
}
}
