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
public final class ConsentStatus {
    /** Unknown consent status. */
    public static const unknown:uint = 0;
    /** User consent required but not yet obtained. */
    public static const required:uint = 1;
    /** Consent not required. */
    public static const notRequired:uint = 2;
    /**  */
    public static const obtained:uint = 3;
}
}