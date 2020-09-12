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
package com.tuarua.admobane

import com.adobe.fre.FREContext
import com.google.android.ump.ConsentInformation
import com.google.android.ump.ConsentInformation.ConsentStatus
import com.google.android.ump.ConsentInformation.ConsentType
import com.google.android.ump.ConsentRequestParameters
import com.google.android.ump.UserMessagingPlatform
import com.google.gson.Gson
import com.tuarua.admobane.extensions.toMap
import com.tuarua.frekotlin.FreKotlinController

class ConsentController(override var context: FREContext?) : FreKotlinController {

    private val consentInformation: ConsentInformation
        get() {
            return UserMessagingPlatform.getConsentInformation(context?.activity?.applicationContext)
        }

    fun requestConsentInfoUpdate(parameters: ConsentRequestParameters, callbackId: String) {
        consentInformation.requestConsentInfoUpdate(
                context?.activity,
                parameters,
                {
                    dispatchEvent(ConsentEvent.ON_CONSENT_INFO_UPDATE, Gson().toJson(
                            ConsentEvent(callbackId,
                                    mapOf("consentStatus" to normalizeConsentStatus(consentInformation.consentStatus),
                                            "consentType" to normalizeConsentType(consentInformation.consentType),
                                            "formStatus" to (if (consentInformation.isConsentFormAvailable) 1 else 2)
                                    )))
                    )
                },
                {
                    dispatchEvent(ConsentEvent.ON_CONSENT_FORM_DISMISSED, Gson().toJson(
                            ConsentEvent(callbackId, error = it.toMap()))
                    )
                })
    }

    fun showConsentForm(callbackId: String) {
        UserMessagingPlatform.loadConsentForm(context?.activity?.applicationContext, { form ->
            if (consentInformation.consentStatus == ConsentStatus.REQUIRED) {
                form.show(context?.activity) { error ->
                    if (error != null) {
                        dispatchEvent(ConsentEvent.ON_CONSENT_FORM_DISMISSED, Gson().toJson(
                                ConsentEvent(callbackId, error = error.toMap()))
                        )
                        return@show
                    }
                    dispatchEvent(ConsentEvent.ON_CONSENT_FORM_DISMISSED, Gson().toJson(
                            ConsentEvent(callbackId,
                                    mapOf("consentStatus" to normalizeConsentStatus(consentInformation.consentStatus),
                                            "consentType" to normalizeConsentType(consentInformation.consentType),
                                            "formStatus" to (if (consentInformation.isConsentFormAvailable) 1 else 2)
                                    )))
                    )
                }
            }
        }, {
            dispatchEvent(ConsentEvent.ON_CONSENT_FORM_DISMISSED, Gson().toJson(
                    ConsentEvent(callbackId, error = it.toMap()))
            )
        })
    }

    fun resetConsent() {
        consentInformation.reset()
    }

    private fun normalizeConsentType(consentType: Int): Int = when (consentType) {
        ConsentType.PERSONALIZED -> 1
        ConsentType.NON_PERSONALIZED -> 2
        else -> consentType
    }

    private fun normalizeConsentStatus(consentStatus: Int): Int = when (consentStatus) {
        ConsentStatus.REQUIRED -> 1
        ConsentStatus.NOT_REQUIRED -> 2
        else -> consentStatus
    }

    override val TAG: String?
        get() = this::class.java.canonicalName
}