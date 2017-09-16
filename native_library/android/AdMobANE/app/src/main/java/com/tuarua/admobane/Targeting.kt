/*
 *  Copyright 2017 Tua Rua Ltd.
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
package com.tuarua.admobane

import com.adobe.fre.FREObject
import com.google.android.gms.ads.AdRequest
import com.tuarua.frekotlin.*
import java.util.*

class Targeting() {
    var birthday: Date? = null
    var gender: Int = AdRequest.GENDER_UNKNOWN
    var forChildren: Boolean? = null

    constructor(freObject: FREObject?) : this() {
        val o = freObject ?: return
        val _gender = Int(o.getProp("gender"))
        if(_gender != null) gender = _gender

        val _forChildrenSet = Boolean(o.getProp("forChildrenSet"))
        val _forChildren = Boolean(o.getProp("forChildren"))
        if (_forChildrenSet != null && _forChildrenSet && _forChildren != null) {
            forChildren = _forChildren
        }
        val birthdayFre = o.getProperty("birthday")
        if (FreObjectTypeKotlin.DATE == birthdayFre?.type){
            birthday = Date(birthdayFre)
        }
    }

}