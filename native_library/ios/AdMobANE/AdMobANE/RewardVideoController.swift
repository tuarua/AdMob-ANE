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

class RewardVideoController: NSObject, FreSwiftController, GADFullScreenContentDelegate {
    static var TAG = "RewardVideoController"
    internal var context: FreContextSwift!
    private var _showOnLoad = true
    private var _airVC: UIViewController?
    private var isPersonalised = true
    private var adView: GADRewardedAd?
    
    convenience init(context: FreContextSwift, isPersonalised: Bool) {
        self.init()
        self.context = context
        self.isPersonalised = isPersonalised
    }
    func load(airVC: UIViewController, unitId: String, deviceList: [String]?,
              targeting: Targeting?, showOnLoad: Bool) {
        _airVC = airVC
        _showOnLoad = showOnLoad

        let request = GADRequest()
        if !isPersonalised {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = deviceList

        if let t = targeting {
            if let fc = t.tagForChildDirectedTreatment {
                GADMobileAds.sharedInstance().requestConfiguration.tag(forChildDirectedTreatment: fc)
            }
            if let fua = t.tagForUnderAgeOfConsent {
                GADMobileAds.sharedInstance().requestConfiguration.tagForUnderAge(ofConsent: fua)
            }
            if let mcr = t.maxAdContentRating {
                GADMobileAds.sharedInstance().requestConfiguration.maxAdContentRating = mcr
            }
            if let contentUrl = t.contentUrl {
                request.contentURL = contentUrl
            }
        }
        
        GADRewardedAd.load(withAdUnitID: unitId, request: request) { ad, error in
            if let error = error as NSError? {
                var props = [String: Any]()
                props["position"] = Position.reward.rawValue
                props["errorCode"] = error.code
                self.dispatchEvent(name: Constants.ON_LOAD_FAILED, value: JSON(props).description)
            } else {
                var props = [String: Any]()
                props["position"] = Position.reward.rawValue
                self.dispatchEvent(name: Constants.ON_LOADED, value: JSON(props).description)
                
                self.adView = ad
                
                guard let av = self.adView, let avc = self._airVC else { return }
                if self._showOnLoad {
                    av.present(fromRootViewController: avc) {
                        let reward = av.adReward
                        var props = [String: Any]()
                        props["position"] = Position.reward.rawValue
                        props["type"] = reward.type
                        props["amount"] = reward.amount
                        self.dispatchEvent(name: Constants.ON_REWARDED, value: JSON(props).description)
                    }
                }
            }
        }
    }
    
    func show() {
        guard let av = adView, let avc = _airVC else { return }
        av.present(fromRootViewController: avc) {
            let reward = av.adReward
            var props = [String: Any]()
            props["position"] = Position.reward.rawValue
            props["type"] = reward.type
            props["amount"] = reward.amount
            self.dispatchEvent(name: Constants.ON_REWARDED, value: JSON(props).description)
        }
    }
    
    func dispose() {
        adView = nil
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        var props = [String: Any]()
        props["position"] = Position.reward.rawValue
        dispatchEvent(name: Constants.ON_OPENED, value: JSON(props).description)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        var props = [String: Any]()
        props["position"] = Position.reward.rawValue
        dispatchEvent(name: Constants.ON_CLOSED, value: JSON(props).description)
    }
    
}
