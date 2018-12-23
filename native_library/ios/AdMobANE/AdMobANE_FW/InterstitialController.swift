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
class InterstitialController: NSObject, FreSwiftController, GADInterstitialDelegate {
    static var TAG = "InterstitialController"

    internal var context: FreContextSwift!
    private var adView: GADInterstitial?
    private var _showOnLoad: Bool = true
    private var _airVC: UIViewController?
    private var isPersonalised: Bool = true
    convenience init(context: FreContextSwift, isPersonalised: Bool) {
        self.init()
        self.context = context
        self.isPersonalised = isPersonalised
    }
    
    func load(airVC: UIViewController, unitId: String, deviceList: [String]?,
              targeting: Targeting?, showOnLoad: Bool) {
        _airVC = airVC
        _showOnLoad = showOnLoad
        adView = GADInterstitial(adUnitID: unitId)
        adView?.delegate = self
        let request = GADRequest()
        if !isPersonalised {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        if deviceList != nil {
            request.testDevices = deviceList!
        }
        
        if let t = targeting {
            if let fc = t.forChildren {
                request.tag(forChildDirectedTreatment: fc)
            }
            if let contentUrl = t.contentUrl {
                request.contentURL = contentUrl
            }
            
        }
        adView?.load(request)
    }
    
    func show() {
        guard let av = adView, let avc = _airVC else {return}
        if av.isReady {
            av.present(fromRootViewController: avc)
        } else {
            trace("Ad wasn't ready")
        }
    }
    
    func dispose() {
        guard let av = adView else {
            return
        }
        av.delegate = nil
        adView = nil
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        var props: [String: Any] = Dictionary()
        props["position"] = Position.interstitial.rawValue
        let json = JSON(props)
        dispatchEvent(name: Constants.ON_LOADED, value: json.description)
        
        guard let av = adView, let avc = _airVC else {return}
        if _showOnLoad {
            av.present(fromRootViewController: avc)
        }
        
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        var props: [String: Any] = Dictionary()
        props["position"] = Position.interstitial.rawValue
        props["errorCode"] = error.code
        let json = JSON(props)
        dispatchEvent(name: Constants.ON_LOAD_FAILED, value: json.description)
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        var props: [String: Any] = Dictionary()
        props["position"] = Position.interstitial.rawValue
        let json = JSON(props)
        dispatchEvent(name: Constants.ON_OPENED, value: json.description)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        var props: [String: Any] = Dictionary()
        props["position"] = Position.interstitial.rawValue
        let json = JSON(props)
        dispatchEvent(name: Constants.ON_CLOSED, value: json.description)
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        var props: [String: Any] = Dictionary()
        props["position"] = Position.interstitial.rawValue
        let json = JSON(props)
        dispatchEvent(name: Constants.ON_LEFT_APPLICATION, value: json.description)
    }
    
}
