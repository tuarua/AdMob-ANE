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

import Foundation
import CoreImage
import GoogleMobileAds
import UserMessagingPlatform

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var bannerController: BannerController?
    private var interstitialController: InterstitialController?
    private var rewardVideoController: RewardVideoController?
    
    private var _consentController: ConsentController?
    private var pListDict: NSDictionary?
    var consentController: ConsentController {
        if _consentController == nil {
            _consentController = ConsentController(context: context)
        }
        return _consentController!
    }
    
    private var deviceArray: [String] = []

    func requestConsentInfoUpdate(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let parameters = UMPRequestParameters(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        consentController.requestConsentInfoUpdate(parameters: parameters, callbackId: callbackId)
        return nil
    }
    
    func resetConsent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        consentController.resetConsent()
        return nil
    }
    
    func showConsentForm(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let callbackId = String(argv[0]),
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            else {
                return FreArgError().getError()
        }
        
        consentController.showConsentForm(airVC: rootViewController, callbackId: callbackId)
        return nil
    }
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 5,
            let volume = Float(argv[0]),
            let muted = Bool(argv[1]),
            let isPersonalised = Bool(argv[3]),
            let disableSDKCrashReporting = Bool(argv[4]),
            let disableAutomatedInAppPurchaseReporting = Bool(argv[5])
          else {
            return FreArgError().getError()
        }

        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().applicationVolume = volume
        GADMobileAds.sharedInstance().applicationMuted = muted
        
        if disableSDKCrashReporting {
            GADMobileAds.sharedInstance().disableSDKCrashReporting()
        }
        if disableAutomatedInAppPurchaseReporting {
            GADMobileAds.sharedInstance().disableAutomatedInAppPurchaseReporting()
        }
        
        bannerController = BannerController(context: context, isPersonalised: isPersonalised)
        interstitialController = InterstitialController(context: context, isPersonalised: isPersonalised)
        rewardVideoController = RewardVideoController(context: context, isPersonalised: isPersonalised)
        
        return nil
    }

    func loadBanner(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 6,
              let inFRE2 = argv[2], //targeting
              let unitId = String(argv[0]),
              let adSize = Int(argv[1]),
              let x = CGFloat(argv[3]),
              let y = CGFloat(argv[4]),
              let hAlign = String(argv[5]),
              let vAlign = String(argv[6])
          else {
            return FreArgError().getError()
        }

        let targeting = Targeting(freObject: inFRE2)
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
           let avc = bannerController {
            avc.load(airView: rootViewController.view, unitId: unitId, size: adSize, deviceList: deviceArray,
              targeting: targeting, x: x, y: y, hAlign: hAlign, vAlign: vAlign)

        }

        return nil
    }

    func clearBanner(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let bc = bannerController else {
            return nil
        }
        bc.clear()
        return nil
    }

    func loadInterstitial(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
              let inFRE1 = argv[1],
              let unitId = String(argv[0]),
              let showOnLoad = Bool(argv[2])
          else {
            return FreArgError().getError()
        }

        let targeting = Targeting(freObject: inFRE1)

        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
           let ivc = interstitialController {
            ivc.load(airVC: rootViewController, unitId: unitId, deviceList: deviceArray,
                     targeting: targeting, showOnLoad: showOnLoad)
        }

        return nil
    }
    
    func showInterstitial(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let ivc = interstitialController {
            ivc.show()
        }
        return nil
    }
  
    func loadRewardVideo(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let inFRE1 = argv[1],
            let unitId = String(argv[0]),
            let showOnLoad = Bool(argv[2])
            else {
                return FreArgError().getError()
        }
        
        let targeting = Targeting(freObject: inFRE1)
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
            let rvc = rewardVideoController {
            rvc.load(airVC: rootViewController, unitId: unitId, deviceList: deviceArray,
                     targeting: targeting, showOnLoad: showOnLoad)
        }
        return nil
    }

    func showRewardVideo(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let rvc = rewardVideoController {
            rvc.show()
        }
        return nil
    }
  
    func getBannerSizes(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let bc = bannerController else {
            return nil
        }
        return FREArray(intArray: bc.getBannerSizes())?.rawValue
    }

    func setTestDevices(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
              let deviceArray = [String](argv[0])
          else {
            return FreArgError().getError()
        }
        self.deviceArray = deviceArray
        return nil
    }

    @objc public func dispose() {
        bannerController?.dispose()
        interstitialController?.dispose()
        rewardVideoController?.dispose()
        bannerController = nil
        interstitialController = nil
        rewardVideoController = nil
    }

}
