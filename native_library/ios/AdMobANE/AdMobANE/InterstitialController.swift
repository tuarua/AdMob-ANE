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

class InterstitialController: NSObject, FreSwiftController, GADFullScreenContentDelegate {
    static var TAG = "InterstitialController"

    internal var context: FreContextSwift!
    private var adView: GADInterstitialAd?
    private var _showOnLoad = true
    private var _airVC: UIViewController?
    private var isPersonalised = true
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
        
        GADInterstitialAd.load(withAdUnitID: unitId,
                               request: request,
                               completionHandler: { [self] ad, error in
                                
                                if let error = error as NSError? {
                                    var props = [String: Any]()
                                    props["position"] = Position.interstitial.rawValue
                                    props["errorCode"] = error.code
                                    dispatchEvent(name: Constants.ON_LOAD_FAILED, value: JSON(props).description)
                                    return
                                }
                                
                                adView = ad
                                adView?.fullScreenContentDelegate = self

                                var props = [String: Any]()
                                props["position"] = Position.interstitial.rawValue
                                dispatchEvent(name: Constants.ON_LOADED, value: JSON(props).description)
                                
                                guard let av = adView, let avc = _airVC else {return}
                                if _showOnLoad {
                                    av.present(fromRootViewController: avc)
                                }
                               }
        )
    }
    
    func show() {
        guard let av = adView, let avc = _airVC else { return }
        av.present(fromRootViewController: avc)
    }
    
    func dispose() {
        guard let av = adView else {
            return
        }
        av.fullScreenContentDelegate = nil
        adView = nil
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        var props = [String: Any]()
        props["position"] = Position.interstitial.rawValue
        dispatchEvent(name: Constants.ON_OPENED, value: JSON(props).description)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        var props = [String: Any]()
        props["position"] = Position.interstitial.rawValue
        dispatchEvent(name: Constants.ON_CLOSED, value: JSON(props).description)
    }
    
}
