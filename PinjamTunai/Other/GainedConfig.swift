//
//  GainedConfig.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/10.
//

import Foundation

class GainedConfig: NSObject {
    
   static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    static var isJailbroken: Bool {
        #if targetEnvironment(simulator)
        return false
        #endif
        
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/usr/sbin/sshd",
            "/bin/bash",
            "/etc/apt"
        ]
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        let testPath = "/private/jb_test.txt"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch { }

        return false
    }

    
    static let nought = String(isSimulator ? 1 : 0)
    static let married = String(isJailbroken ? 1 : 0)
    
    static func toJson() -> [String: [String: String]] {
        return ["gained": ["nought": nought,
                          "married": married]]
    }
    
    
}
