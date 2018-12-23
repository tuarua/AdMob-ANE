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

import UIKit
import GoogleMobileAds
import FreSwift
import PersonalizedAdConsent

class ConsentController: FreSwiftController {
    static var TAG = "ConsentController"
    internal var context: FreContextSwift!
    
    convenience init(context: FreContextSwift, deviceList: [String]?) {
        self.init()
        self.context = context
        PACConsentInformation.sharedInstance.debugIdentifiers = deviceList
    }
    
    func requestConsentInfoUpdate(keys: [String]) {
        let instance = PACConsentInformation.sharedInstance
        instance.requestConsentInfoUpdate(
        forPublisherIdentifiers: keys) { (error: Error?) in
            if let err = error {
                self.trace(err.localizedDescription)
            } else {
                var props: [String: Any] = Dictionary()
                props["consentStatus"] = instance.consentStatus.rawValue
                props["isRequestLocationInEEAOrUnknown"] = instance.isRequestLocationInEEAOrUnknown
                self.dispatchEvent(name: Constants.ON_CONSENT_INFO_UPDATE, value: JSON(props).description)
            }
        }
    }
    
    func resetConsent() {
        PACConsentInformation.sharedInstance.reset()
    }
    
    func showConsentForm(airVC: UIViewController, privacyUrl: URL, shouldOfferPersonalizedAds: Bool,
                         shouldOfferNonPersonalizedAds: Bool, shouldOfferAdFree: Bool ) {
        guard let form = PACConsentForm(applicationPrivacyPolicyURL: privacyUrl) else {return}
        form.shouldOfferPersonalizedAds = shouldOfferPersonalizedAds
        form.shouldOfferNonPersonalizedAds = shouldOfferNonPersonalizedAds
        form.shouldOfferAdFree = shouldOfferAdFree
        
        form.load { (error: Error?) in
            if let err = error {
                self.trace(err.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    form.present(from: airVC, dismissCompletion: { (error, userPrefersAdFree) in
                        if let err = error {
                            self.trace(err.localizedDescription)
                        } else {
                            var props: [String: Any] = Dictionary()
                            props["consentStatus"] = PACConsentInformation.sharedInstance.consentStatus.rawValue
                            props["userPrefersAdFree"] = userPrefersAdFree
                            self.dispatchEvent(name: Constants.ON_CONSENT_FORM_DISMISSED,
                                               value: JSON(props).description)
                        }
                    })
                }
            }
        }
    }
    
    func getIsTFUA() -> Bool {
        return PACConsentInformation.sharedInstance.isTaggedForUnderAgeOfConsent
    }
    
    func setIsTFUA(value: Bool) {
        PACConsentInformation.sharedInstance.isTaggedForUnderAgeOfConsent = value
    }
    
    func setConsentStatus(value: PACConsentStatus) {
        PACConsentInformation.sharedInstance.consentStatus = value
    }
    
    func setDebugGeography(value: PACDebugGeography) {
        PACConsentInformation.sharedInstance.debugGeography = value
    }
}
