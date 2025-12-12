//
//  Untitled.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit
import AdSupport
import Security

class LoginConfig: NSObject {
    
    static func saveLoginInfo(to phone: String, token: String) {
        UserDefaults.standard.setValue(phone, forKey: "phone")
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
    static func deleteLoginInfo() {
        UserDefaults.standard.removeObject(forKey: "phone")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
    static func hasValidToken() -> Bool {
        return UserDefaults.standard.string(forKey: "token")?.isEmpty == false
    }
    
    static func getPhone() -> String {
        return UserDefaults.standard.string(forKey: "phone") ?? ""
    }
}

class DeviceIdentifierManager {
    
    static func getIDFA() -> String? {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if idfa == "00000000-0000-0000-0000-000000000000" {
            return ""
        }
        return idfa
    }
    
    static func getIDFV() -> String? {
        if let existingID = readIDFVFromKeychain() {
            return existingID
        }
        
        guard let newID = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }
        
        saveIDFVToKeychain(newID)
        
        return newID
    }
    
    private static func saveIDFVToKeychain(_ idfv: String) {
        let service = Bundle.main.bundleIdentifier ?? "com.app.PinjamTunaiApp"
        let account = "device_idfv"
        
        deleteFromKeychain(service: service, account: account)
        
        guard let data = idfv.data(using: .utf8) else {
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("IDFV=====SUCCESS")
        } else {
            print("ERROR=====: \(status)")
        }
    }
    
    static func readIDFVFromKeychain() -> String? {
        let service = Bundle.main.bundleIdentifier ?? "com.app.PinjamTunaiApp"
        let account = "device_idfv"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            print("error=====: \(status)")
            return nil
        }
    }
    
    private static func deleteFromKeychain(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    static func getDeviceIdentifier() -> String {
        if let savedIDFV = readIDFVFromKeychain() {
            return savedIDFV
        }
        
        return getIDFV() ?? ""
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        if hexFormatted.count == 6 {
            hexFormatted += "FF"
        } else if hexFormatted.count == 3 {
            hexFormatted = hexFormatted.map { "\($0)\($0)" }.joined() + "FF"
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
            blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
            alpha: CGFloat(rgbValue & 0x000000FF) / 255.0
        )
    }
}

class JSONConverter {
    static func convertToJSONString(_ object: [[String: String]]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            return ""
        }
        return ""
    }
    
}
