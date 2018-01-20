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


class BannerController: UIViewController, FreSwiftController, GADBannerViewDelegate {
    var TAG: String? = "AdMobANE"
    internal var context: FreContextSwift!
    private var adView: GADBannerView!
    private var _size:Int = 0
    private var _airView: UIView!
    private var _hAlign: String = "center"
    private var _vAlign: String = "bottom"
    private var _x: CGFloat = CGFloat.init()
    private var _y: CGFloat = CGFloat.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect.zero
        NotificationCenter.default.addObserver(self, selector: #selector(BannerController.orientationDidChange(notification:)), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
    }

    @objc private func orientationDidChange(notification: Notification) {
        guard let _ = _airView, let _ = adView, let uiDevice = notification.object as? UIDevice else {
            return
        }

        if(_size == 5) {
            if(uiDevice.orientation == .portrait
                || uiDevice.orientation == .portraitUpsideDown
                || uiDevice.orientation == .faceUp
                || uiDevice.orientation == .faceDown
                || uiDevice.orientation == .unknown ) {
                adView.adSize = kGADAdSizeSmartBannerPortrait
            } else if(uiDevice.orientation == .landscapeLeft || uiDevice.orientation == .landscapeRight){
                adView.adSize = kGADAdSizeSmartBannerLandscape
            }
        }
        
        position()

    }

    private func position() {
        guard let airv = _airView, let adV = adView else {
            return
        }
        var theX: CGFloat = CGFloat.init()
        var theY: CGFloat = CGFloat.init()
        //handle smart banners separately
        let theW: CGFloat = adV.adSize.size.width > 0.0 ? adV.adSize.size.width : adV.frame.width
        let theH: CGFloat = adV.adSize.size.width > 0.0 ? adV.adSize.size.height : adV.frame.height
        
        //TODO x and y supersede aligns
        if (_hAlign == "center") {
            theX = airv.center.x - (theW / 2)
        } else if (_hAlign == "right") {
            theX = airv.frame.width - theW
        }
        
        if (_vAlign == "center") {
            theY = airv.center.y - (theH / 2)
        } else if (_vAlign == "bottom") {
            theY = airv.frame.height - theH
        }
        self.view.frame = CGRect.init(origin: CGPoint.init(x: theX, y: theY),
                                      size: CGSize.init(width: theW, height: theH))
    }


    func load(airView: UIView, unitId: String, size: Int, deviceList: Array<String>?, targeting: Targeting?,
              x: CGFloat, y: CGFloat, hAlign: String, vAlign: String) {
        _size = size
        _airView = airView
        _hAlign = hAlign
        _vAlign = vAlign
        _x = x
        _y = y

        if adView == nil {
            adView = GADBannerView()
            adView.delegate = self
            view.addSubview(adView)
            adView.translatesAutoresizingMaskIntoConstraints = false
            if (self.view.superview != airView) {
                airView.addSubview(self.view)
            }
        }

        adView.adUnitID = unitId
        adView.rootViewController = self

        switch _size {
            case 0:
                adView.adSize = kGADAdSizeBanner
                break
            case 1:
                adView.adSize = kGADAdSizeFullBanner
                break
            case 2:
                adView.adSize = kGADAdSizeLargeBanner
                break
            case 3:
                adView.adSize = kGADAdSizeLeaderboard
                break
            case 4:
                adView.adSize = kGADAdSizeMediumRectangle
                break
            case 5:
                if(UIDevice.current.orientation == .portrait
                    || UIDevice.current.orientation == .portraitUpsideDown
                    || UIDevice.current.orientation == .faceUp
                    || UIDevice.current.orientation == .faceDown
                    || UIDevice.current.orientation == .unknown ) {
                    adView.adSize = kGADAdSizeSmartBannerPortrait
                } else if(UIDevice.current.orientation == .landscapeLeft
                    || UIDevice.current.orientation == .landscapeRight){
                    adView.adSize = kGADAdSizeSmartBannerLandscape
                }
                break
            default:
                adView.adSize = kGADAdSizeBanner
                break
        }

        position()

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

    func getBannerSizes() -> Array<Int> {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone, .unspecified:
            return [0, 2, 5]
        case .pad:
            return [0, 1, 2, 3, 4, 5]
        default:
            break
        }
        return [-1]
    }

    func clear() {
        guard let av = adView else {
            return
        }
        av.delegate = nil
        av.removeFromSuperview()
        self.view.removeFromSuperview() //check does this break ?
        adView = nil
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.banner.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_LOADED, value: json.description)
        
        //handle smart banners separately
        guard let adV = adView, adV.adSize.size.width < 0.1 else {
            return
        }
        position()
    }
    
    func dispose(){
        clear()
        self.removeFromParentViewController()
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        //trace("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.banner.rawValue
        props["errorCode"] = error.code
        let json = JSON(props)
        sendEvent(name: Constants.ON_LOAD_FAILED, value: json.description)
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        var props: Dictionary<String, Any> = Dictionary()
        props["position"] = Position.banner.rawValue
        let json = JSON(props)
        sendEvent(name: Constants.ON_LEFT_APPLICATION, value: json.description)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

}
