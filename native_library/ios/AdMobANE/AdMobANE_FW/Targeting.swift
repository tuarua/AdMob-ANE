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
    public var birthday: Date?
    public var gender: GADGender = .unknown
    public var forChildren: Bool?
    public var contentUrl: String?

    init(freObject: FREObject?) {
        guard let o = freObject else {
            return
        }

        do {
            if let g = try Int(o.getProp(name: "gender")) {
                switch g {
                case 1:
                    gender = .male
                case 2:
                    gender = .female
                default:
                    gender = .unknown
                }
            }
            let forChildrenSet = try Bool(o.getProp(name: "forChildrenSet")) == true
            if forChildrenSet {
                forChildren = try Bool(o.getProp(name: "forChildren"))
            }
            if let birthdayFre = try o.getProp(name: "birthday") {
                if FreObjectTypeSwift.date == birthdayFre.type {
                    if let d = Date(birthdayFre) {
                        birthday = d
                    }
                }
            }
            
            if let contentUrlFre = try o.getProp(name: "contentUrl") {
                contentUrl = String(contentUrlFre)
            }

        } catch let e as FreError {
            _ = e.getError(#file, #line, #column)
        } catch {
        }

    }
}
