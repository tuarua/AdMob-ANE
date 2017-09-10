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
    public var birthday: Date? = nil
    public var gender: GADGender = .unknown
    public var forChildren: Bool? = nil
    public var contentUrl: String?

    init(freObjectSwift: FreObjectSwift?) {
        guard let o = freObjectSwift else {
            return
        }

        do {
            if let g = try o.getProperty(name: "gender")?.value as? Int {
                switch g {
                case 1:
                    gender = .male
                case 2:
                    gender = .female
                default:
                    gender = .unknown
                }
            }
            let forChildrenSet = try o.getProperty(name: "forChildrenSet")?.value as! Bool
            if forChildrenSet {
                forChildren = try o.getProperty(name: "forChildren")?.value as? Bool
            }
            if let birthdayFre = try o.getProperty(name: "birthday") {
                Swift.debugPrint("birthdayFre.getType(): \(birthdayFre.getType())")
                if FreObjectTypeSwift.date == birthdayFre.getType() {
                    if let d = birthdayFre.value as? Date {
                        birthday = d
                    }
                }
            }
            
            if let contentUrlFre = try o.getProperty(name: "contentUrl") {
                contentUrl = contentUrlFre.value as? String
            }

        } catch let e as FreError {
            _ = e.getError(#file, #line, #column)
        } catch {
        }


    }
}
