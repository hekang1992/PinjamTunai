//
//  ProudConfig.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
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
    
    static func toJson() -> [String: [String: Int]] {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        let isCharging = UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full ? 1 : 0
        
        return ["anchorite": ["cosy": batteryLevel,
                              "cell": isCharging]]
    }
    
}

class HelpConfig: NSObject {
    
    static let miles = NSTimeZone.system.abbreviation() ?? ""
    static let eating = DeviceIdentifierManager.getDeviceIdentifier()
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
    
    static func toJson() -> [String :[String: [String: String]]] {
        return ["dwelleth": ["abbey": ["fountain": getBSSID() ?? "",
                                       "bore": getNameSSID() ?? ""]]]
    }
    
}
