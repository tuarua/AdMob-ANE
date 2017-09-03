//
//  InterstitialController.swift
//  AdMobANE
//
//  Created by Eoin Landy on 03/09/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FreSwift
class InterstitialController: NSObject, FreSwiftController, GADInterstitialDelegate {
    internal var context: FreContextSwift!
    private var adView: GADInterstitial!
    private var _showOnLoad:Bool = true
    private var _airVC:UIViewController?
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
    }
    
    func load(airVC: UIViewController, unitId: String, deviceList: Array<String>?, targeting: Targeting?, showOnLoad:Bool){
        _airVC = airVC
        _showOnLoad = showOnLoad
        adView = GADInterstitial(adUnitID: unitId)
        adView.delegate = self
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
        adView.load(request)
    }
    
    func show() {
        guard let av = adView, let avc = _airVC else {return}
        if av.isReady {
            av.present(fromRootViewController: avc)
        } else {
            trace("Ad wasn't ready")
        }
        
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.interstitial.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_LOADED, value: json.description)
        
        guard let av = adView, let avc = _airVC else {return}
        if(_showOnLoad) {
            av.present(fromRootViewController: avc)
        }
        
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        trace("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.interstitial.rawValue
        props["errorCode"] = error.code
        let json = JSON(props)
        sendEvent(name: Constants.ON_LOAD_FAILED, value: json.description)
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.interstitial.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_OPENED, value: json.description)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.interstitial.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_CLOSED, value: json.description)
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.interstitial.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_LEFT_APPLICATION, value: json.description)
    }
    
}
