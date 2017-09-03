/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/

#import "FreMacros.h"
#import <FreSwift/FlashRuntimeExtensions.h>

#import "AdMobANE_LIB.h"
#import "FreSwift-iOS-Swift.h"
#import "AdMobANE_FW-Swift.h"

#define FRE_OBJC_BRIDGE TRAMA_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end


SWIFT_DECL(TRAMA) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRAMA) {
    SWIFT_INITS(TRAMA)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/

    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRAMA, isSupported)
        ,MAP_FUNCTION(TRAMA, init)
        ,MAP_FUNCTION(TRAMA, loadBanner)
        ,MAP_FUNCTION(TRAMA, clearBanner)
        ,MAP_FUNCTION(TRAMA, loadInterstitial)
        ,MAP_FUNCTION(TRAMA, showInterstitial)
        ,MAP_FUNCTION(TRAMA, getBannerSizes)
        ,MAP_FUNCTION(TRAMA, setTestDevices)
    };
    
   
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRAMA) {
    //any clean up code here
}
EXTENSION_INIT(TRAMA)
EXTENSION_FIN(TRAMA)
