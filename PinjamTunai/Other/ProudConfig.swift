//
//  ProudConfig.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/10.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork

class ProudConfig: NSObject {
    
    static let uncle = UIDevice.current.systemVersion
    static let speakest = "iPhone"
    static let coz = ApiPeraConfig.getDeviceModel()
    
    static func toJson() -> [String: [String: String]] {
        return ["proud": ["uncle": uncle,
                          "speakest": speakest,
                          "coz": coz]]
    }
}


class AnchoriteConfig: NSObject {
    
    static func getBatteryLevel() -> Int {
        let level = UIDevice.current.batteryLevel
        guard level >= 0 else { return -1 }
        return Int(level)
    }
    
    static func isCharging() -> Int {
        switch UIDevice.current.batteryState {
        case .charging, .full:
            return 1
        default:
            return 0
        }
    }
    
    
    static let cosy = String(getBatteryLevel())
    static let cell = String(isCharging())
    
    static func toJson() -> [String: [String: String]] {
        return ["anchorite": ["cosy": cosy,
                              "cell": cell]]
    }
}

class HelpConfig: NSObject {
    
    static let miles = NSTimeZone.system.abbreviation() ?? ""
    static let eating = DeviceIdentifierManager.getIDFV() ?? ""
    static let became = Locale.preferredLanguages.first ?? "en_US"
    static let hundred = UserDefaults.standard.object(forKey: "network") as? String ?? ""
    static let lovers = DeviceIdentifierManager.getIDFA() ?? ""
    
    static func toJson() -> [String: [String: String]] {
        return ["help": ["miles": miles,
                         "eating": eating,
                         "became": became,
                         "hundred": hundred,
                         "lovers": lovers]]
    }
}

class DwellethConfig: NSObject {
    
    class func getBSSID() -> String? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return nil
        }
        
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any] else {
                continue
            }
            
            if let bssid = interfaceInfo["BSSID"] as? String {
                return bssid
            }
        }
        
        return nil
    }
    
    class func getNameSSID() -> String? {
        var currentSSID = ""
        if let myArray = CNCopySupportedInterfaces() as? [String],
           let interface = myArray.first as CFString?,
           let myDict = CNCopyCurrentNetworkInfo(interface) as NSDictionary? {
            currentSSID = myDict["SSID"] as? String ?? ""
        } else {
            currentSSID = ""
        }
        return currentSSID
    }
    
    static func toJson() -> [String: [String: String]] {
        return ["abbey": ["fountain": getBSSID() ?? "",
                         "bore": getNameSSID() ?? ""]]
    }
    
}
