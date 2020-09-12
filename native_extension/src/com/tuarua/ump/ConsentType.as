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
public final class ConsentType {
    /** User consent either not obtained or personalized vs non-personalized status undefined. */
    public static const unknown:uint = 0;
    /** User consented to personalized ads. */
    public static const personalized:uint = 1;
    /** User consented to non-personalized ads. */
    public static const nonPersonalized:uint = 2;
}
}
