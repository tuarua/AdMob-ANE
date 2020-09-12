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
import SwiftyJSON
import UserMessagingPlatform

class ConsentController: FreSwiftController {
    static var TAG = "ConsentController"
    internal var context: FreContextSwift!
    
    private let consentInformation = UMPConsentInformation.sharedInstance
    
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
    }
    
    func requestConsentInfoUpdate(parameters: UMPRequestParameters, callbackId: String) {
        consentInformation.requestConsentInfoUpdate(with: parameters) { error in
            if let err = error as NSError? {
                self.dispatchEvent(name: ConsentEvent.ON_CONSENT_INFO_UPDATE,
                                   value: ConsentEvent(callbackId: callbackId,
                                    error: err).toJSONString())
            } else {
                var props = [String: Any]()
                props["consentStatus"] = self.consentInformation.consentStatus.rawValue
                props["consentType"] = self.consentInformation.consentType.rawValue
                props["formStatus"] = self.consentInformation.formStatus.rawValue
                self.dispatchEvent(name: ConsentEvent.ON_CONSENT_INFO_UPDATE,
                                   value: ConsentEvent(callbackId: callbackId, data: props).toJSONString())
                
            }
        }
    }
    
    func resetConsent() {
        UMPConsentInformation.sharedInstance.reset()
    }
    
    func showConsentForm(airVC: UIViewController, callbackId: String) {
        let formStatus = consentInformation.formStatus
        if formStatus == .available {
            UMPConsentForm.load { form, error in
                if let err = error as NSError? {
                    self.dispatchEvent(name: ConsentEvent.ON_CONSENT_FORM_DISMISSED,
                                       value: ConsentEvent(callbackId: callbackId,
                                                           error: err).toJSONString())
                } else {
                    DispatchQueue.main.async {
                        form?.present(from: airVC, completionHandler: { error in
                            if let err = error as NSError? {
                                self.dispatchEvent(name: ConsentEvent.ON_CONSENT_FORM_DISMISSED,
                                                   value: ConsentEvent(callbackId: callbackId,
                                                                       error: err).toJSONString())
                            } else {
                                var props = [String: Any]()
                                props["consentStatus"] = self.consentInformation.consentStatus.rawValue
                                props["consentType"] = self.consentInformation.consentType.rawValue
                                props["formStatus"] = self.consentInformation.formStatus.rawValue
                                
                                self.dispatchEvent(name: ConsentEvent.ON_CONSENT_FORM_DISMISSED,
                                                   value: ConsentEvent(callbackId: callbackId,
                                                                       data: props).toJSONString())
                            }
                        })
                    }
                }
            }
        }
    }

}
