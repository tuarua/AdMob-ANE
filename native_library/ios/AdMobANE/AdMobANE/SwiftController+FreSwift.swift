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
import FreSwift

extension SwiftController: FreSwiftMainController {
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)requestConsentInfoUpdate"] = requestConsentInfoUpdate
        functionsToSet["\(prefix)resetConsent"] = resetConsent
        functionsToSet["\(prefix)showConsentForm"] = showConsentForm
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)loadBanner"] = loadBanner
        functionsToSet["\(prefix)clearBanner"] = clearBanner
        functionsToSet["\(prefix)loadInterstitial"] = loadInterstitial
        functionsToSet["\(prefix)showInterstitial"] = showInterstitial
        functionsToSet["\(prefix)getBannerSizes"] = getBannerSizes
        functionsToSet["\(prefix)setTestDevices"] = setTestDevices
        functionsToSet["\(prefix)loadRewardVideo"] = loadRewardVideo
        functionsToSet["\(prefix)showRewardVideo"] = showRewardVideo
        functionsToSet["\(prefix)getIsTFUA"] = getIsTFUA
        functionsToSet["\(prefix)setIsTFUA"] = setIsTFUA
        functionsToSet["\(prefix)setConsentStatus"] = setConsentStatus
        functionsToSet["\(prefix)setDebugGeography"] = setDebugGeography
        
        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }
    
    // Must have these 3 functions. It exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
    }
    
    @objc public func onLoad() {
    }
    
}
