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
public final class ConsentFormStatus {
    /** Whether a consent form is available is unknown. An update should be requested using
     * requestConsentInfo(). */
    public static const unknown:uint = 0;
    /** Consent forms are available and can be loaded using showConsentForm() */
    public static const available:uint = 1;
    /** Consent forms are unavailable. Showing a consent form is not required. */
    public static const unavailable:uint = 2;
}
}