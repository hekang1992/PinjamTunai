//
//  ProudConfig.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

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
        if #available(iOS 14.0, *) {
            var bssid: String?
            let semaphore = DispatchSemaphore(value: 0)
            
            NEHotspotNetwork.fetchCurrent { network in
                bssid = network?.bssid
                semaphore.signal()
            }
            
            _ = semaphore.wait(timeout: .now() + 2.0)
            return bssid
        } else {
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
    }
    
    class func getNameSSID() -> String? {
        if #available(iOS 14.0, *) {
            var ssid: String?
            let semaphore = DispatchSemaphore(value: 0)
            
            NEHotspotNetwork.fetchCurrent { network in
                ssid = network?.ssid
                semaphore.signal()
            }
            
            _ = semaphore.wait(timeout: .now() + 2.0)
            return ssid
        } else {
            guard let interfaces = CNCopySupportedInterfaces() as? [String],
                  let interfaceName = interfaces.first else {
                return nil
            }
            
            guard let networkInfo = CNCopyCurrentNetworkInfo(interfaceName as CFString) as? [String: Any] else {
                return nil
            }
            
            return networkInfo["SSID"] as? String
        }
    }
    
    static func toJson() -> [String: [String: [String: String]]] {
        return ["dwelleth": ["abbey": ["fountain": getBSSID() ?? "",
                                       "bore": getNameSSID() ?? ""]]]
    }
}
