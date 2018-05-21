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

public class SwiftController: NSObject {
    public var TAG: String? = "AdMobANE"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var bannerController: BannerController?
    private var interstitialController: InterstitialController?
    private var rewardVideoController: RewardVideoController?
    private var deviceArray: [String] = []

    func isSupported(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }

    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let key = String(argv[0]),
            let volume = Float(argv[1]),
            let muted = Bool(argv[2]),
            let isPersonalised = Bool(argv[3])
          else {
            return ArgCountError(message: "initAdMob").getError(#file, #line, #column)
        }

        GADMobileAds.configure(withApplicationID: key)
        GADMobileAds.sharedInstance().applicationVolume = volume
        GADMobileAds.sharedInstance().applicationMuted = muted

        bannerController = BannerController.init(context: context, isPersonalised: isPersonalised)
        interstitialController = InterstitialController.init(context: context, isPersonalised: isPersonalised)
        rewardVideoController = RewardVideoController.init(context: context, isPersonalised: isPersonalised)
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
            return ArgCountError(message: "loadBanner").getError(#file, #line, #column)
        }

        let targeting = Targeting.init(freObject: inFRE2)
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
            return ArgCountError(message: "loadInterstitial").getError(#file, #line, #column)
        }

        let targeting = Targeting.init(freObject: inFRE1)

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
                return ArgCountError(message: "loadRewardVideo").getError(#file, #line, #column)
        }
        
        let targeting = Targeting.init(freObject: inFRE1)
        
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
        do {
            let arr = try FREArray.init(intArray: bc.getBannerSizes())
            return arr.rawValue
        } catch {
        }
        return nil
    }

    func setTestDevices(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
              let inFRE0 = argv[0]
          else {
            return ArgCountError(message: "setTestDevices").getError(#file, #line, #column)
        }
        let deviceArrayAny: [Any?] = FREArray.init(inFRE0).value
        for device in deviceArrayAny {
            if let d = device as? String {
                deviceArray.append(d)
            }
        }
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
