//
//  ApiPeraConfig.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit

class ApiPeraConfig: NSObject {
    
    static func getCommonPara() -> [String: String] {
        let broken = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let straightway = getDeviceModel()
        let sit = DeviceIdentifierManager.getDeviceIdentifier()
        let overfull = UIDevice.current.systemVersion
        let mill = UserDefaults.standard.object(forKey: "token") as? String ?? ""
        let weir = DeviceIdentifierManager.getIDFA() ?? ""
        let kissed = UserDefaults.standard.object(forKey: "kissed") as? String ?? ""
        
        let dict = ["broken": broken,
                    "straightway": straightway,
                    "sit": sit,
                    "overfull": overfull,
                    "mill": mill,
                    "weir": weir,
                    "kissed": kissed]
        
//        let jsonStr = JSONHelper.toJSONString(dict)
        
        return dict
    }
    
    
   static func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let mirror = Mirror(reflecting: systemInfo.machine)
        var identifier = ""
        
        for child in mirror.children {
            if let value = child.value as? Int8, value != 0 {
                identifier.append(Character(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }
    
}


class JSONHelper {
    static func toJSONString(_ dict: [String: Any]) -> String {
        guard JSONSerialization.isValidJSONObject(dict) else {
            return ""
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}
