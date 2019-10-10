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
import com.google.ads.consent.*
import com.google.gson.Gson
import com.tuarua.frekotlin.FreKotlinController
import java.net.URL

class ConsentController(override var context: FREContext?) : FreKotlinController {

    val consentInformation: ConsentInformation
        get() {
            return ConsentInformation.getInstance(context?.activity?.applicationContext)
        }

    fun requestConsentInfoUpdate(keys: List<String>) {
        consentInformation.requestConsentInfoUpdate(keys.toTypedArray(),
                object : ConsentInfoUpdateListener {
                    override fun onConsentInfoUpdated(consentStatus: ConsentStatus) {
                        dispatchEvent(Constants.ON_CONSENT_INFO_UPDATE, Gson().toJson(
                                ConsentInfoEvent(consentStatus.ordinal,
                                        consentInformation.isRequestLocationInEeaOrUnknown))
                        )
                    }

                    override fun onFailedToUpdateConsentInfo(errorDescription: String) {
                        // TODO
                        trace("onFailedToUpdateConsentInfo", errorDescription)
                    }
                })
    }

    fun resetConsent() {
        consentInformation.reset()
    }

    fun showConsentForm(privacyUrl: URL, shouldOfferPersonalizedAds: Boolean,
                        shouldOfferNonPersonalizedAds: Boolean, shouldOfferAdFree: Boolean) {
        var form: ConsentForm? = null
        val builder = ConsentForm.Builder(context?.activity, privacyUrl)
                .withListener(object : ConsentFormListener() {
                    override fun onConsentFormClosed(consentStatus: ConsentStatus?,
                                                     userPrefersAdFree: Boolean?) {
                        super.onConsentFormClosed(consentStatus, userPrefersAdFree)
                        dispatchEvent(Constants.ON_CONSENT_FORM_DISMISSED, Gson().toJson(
                                ConsentDismissEvent(consentStatus?.ordinal ?: 0,
                                        userPrefersAdFree == true))
                        )
                    }

                    override fun onConsentFormLoaded() {
                        form?.show()
                    }

                    override fun onConsentFormError(reason: String?) {
                        super.onConsentFormError(reason)
                        trace(reason)
                    }

                })
        if (shouldOfferPersonalizedAds) builder.withPersonalizedAdsOption()
        if (shouldOfferNonPersonalizedAds) builder.withNonPersonalizedAdsOption()
        if (shouldOfferAdFree) builder.withAdFreeOption()
        form = builder.build()
        form?.load()
    }

    fun getIsTFUA(): Boolean {
        return consentInformation.isTaggedForUnderAgeOfConsent
    }

    fun setIsTFUA(value: Boolean) {
        consentInformation.setTagForUnderAgeOfConsent(value)
    }

    fun setDebugGeography(value: DebugGeography) {
        consentInformation.debugGeography = value
    }

    fun setConsentStatus(value: ConsentStatus) {
        consentInformation.consentStatus = value
    }

    override val TAG: String?
        get() = this::class.java.canonicalName
}