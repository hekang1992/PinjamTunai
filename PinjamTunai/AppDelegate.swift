//
//  AppDelegate.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        boardInfo()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LaunchViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
}


extension AppDelegate {
    
    private func boardInfo() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
}
