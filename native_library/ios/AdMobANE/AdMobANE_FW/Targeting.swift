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
import GoogleMobileAds

public struct Targeting {
    public var forChildren: Bool?
    public var contentUrl: String?

    init(freObject: FREObject?) {
        guard let o = freObject else {
            return
        }

        let forChildrenSet = Bool(o["forChildrenSet"]) == true
        if forChildrenSet {
            forChildren = Bool(o["forChildren"])
        }
        if let contentUrlFre = o["contentUrl"] {
            contentUrl = String(contentUrlFre)
        }
    }
}
