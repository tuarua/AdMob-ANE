//
//  Targeting.swift
//  AdMobANE
//
//  Created by Eoin Landy on 03/09/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

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
