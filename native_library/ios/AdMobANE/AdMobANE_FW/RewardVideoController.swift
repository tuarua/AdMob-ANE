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

class RewardVideoController: NSObject, FreSwiftController, GADRewardBasedVideoAdDelegate {
    var TAG: String? = "RewardVideoController"
    internal var context: FreContextSwift!
    private var _showOnLoad:Bool = true
    private var _airVC:UIViewController?
    private var adView: GADRewardBasedVideoAd?
    
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
        
    }
    func load(airVC: UIViewController, unitId: String, deviceList: Array<String>?, targeting: Targeting?, showOnLoad:Bool){
        _airVC = airVC
        _showOnLoad = showOnLoad
        adView = GADRewardBasedVideoAd.sharedInstance()
        
        adView?.delegate = self
        let request = GADRequest()
        if deviceList != nil {
            request.testDevices = deviceList!
        }
        
        if let t = targeting {
            if let fc = t.forChildren {
                request.tag(forChildDirectedTreatment: fc)
            }
            request.gender = t.gender
            if let birthday = t.birthday {
                request.birthday = birthday
            }
            if let contentUrl = t.contentUrl {
                request.contentURL = contentUrl
            }
            
        }
        adView?.load(request, withAdUnitID: unitId)
        
    }
    
    func show() {
        guard let av = adView, let avc = _airVC else {return}
        if av.isReady == true {
            av.present(fromRootViewController: avc)
        }else {
            trace("Ad wasn't ready")
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.reward.rawValue
        props["type"] = reward.type
        props["amount"] = reward.amount
        let json = JSON(props)
        sendEvent(name: Constants.ON_REWARDED, value: json.description)
    }
    
    func dispose(){
        guard let av = adView else {
            return
        }
        av.delegate = nil
        adView = nil
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.reward.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_LOADED, value: json.description)
        
        guard let av = adView, let avc = _airVC else {return}
        if(_showOnLoad) {
            av.present(fromRootViewController: avc)
        }
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.reward.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_OPENED, value: json.description)
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.reward.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_VIDEO_STARTED, value: json.description)
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.reward.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_CLOSED, value: json.description)
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.reward.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_LEFT_APPLICATION, value: json.description)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.reward.rawValue
        props["errorCode"] = 0
        let json = JSON(props)
        sendEvent(name: Constants.ON_LOAD_FAILED, value: json.description)
    }
    
}
