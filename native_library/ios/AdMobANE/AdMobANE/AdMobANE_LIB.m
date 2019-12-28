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

#import "FreMacros.h"
#import "AdMobANE_LIB.h"
#import <FreSwift/FreSwift-iOS-Swift.h>
#import <AdMobANE_FW/AdMobANE_FW.h>

#define FRE_OBJC_BRIDGE TRAMA_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation AdMobANE_LIB
SWIFT_DECL(TRAMA) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRAMA) {
    SWIFT_INITS(TRAMA)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/

    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRAMA, init)
        ,MAP_FUNCTION(TRAMA, loadBanner)
        ,MAP_FUNCTION(TRAMA, clearBanner)
        ,MAP_FUNCTION(TRAMA, loadInterstitial)
        ,MAP_FUNCTION(TRAMA, showInterstitial)
        ,MAP_FUNCTION(TRAMA, getBannerSizes)
        ,MAP_FUNCTION(TRAMA, setTestDevices)
        ,MAP_FUNCTION(TRAMA, loadRewardVideo)
        ,MAP_FUNCTION(TRAMA, showRewardVideo)
        ,MAP_FUNCTION(TRAMA, requestConsentInfoUpdate)
        ,MAP_FUNCTION(TRAMA, resetConsent)
        ,MAP_FUNCTION(TRAMA, showConsentForm)
        ,MAP_FUNCTION(TRAMA, getIsTFUA)
        ,MAP_FUNCTION(TRAMA, setIsTFUA)
        ,MAP_FUNCTION(TRAMA, setConsentStatus)
        ,MAP_FUNCTION(TRAMA, setDebugGeography)
    };

    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRAMA) {
    [TRAMA_swft dispose];
    TRAMA_swft = nil;
    TRAMA_freBridge = nil;
    TRAMA_swftBridge = nil;
    TRAMA_funcArray = nil;
}
EXTENSION_INIT(TRAMA)
EXTENSION_FIN(TRAMA)
@end
