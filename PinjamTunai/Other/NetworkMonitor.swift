//
//  NetworkMonitor.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

import Alamofire

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let reachability = NetworkReachabilityManager()
    
    var networkTypeChanged: ((String) -> Void)?
    
    func startMonitoring() {
        reachability?.startListening(onQueue: .main) { [weak self] status in
            var statusString = "unknown"
            
            switch status {
            case .reachable(.cellular):
                statusString = "5G"
                self?.stopMonitoring()
                print("✅====5G=====")
                
            case .reachable(.ethernetOrWiFi):
                statusString = "WIFI"
                self?.stopMonitoring()
                print("✅====WIFI=====")
                
            case .notReachable:
                statusString = "none"
                print("❌==========")
                
            case .unknown:
                statusString = "unknown"
                print("❓==========")
            }
            
            UserDefaults.standard.set(statusString, forKey: "network")
            UserDefaults.standard.synchronize()
            
            self?.networkTypeChanged?(statusString)
        }
    }
    
    func stopMonitoring() {
        reachability?.stopListening()
    }
}
