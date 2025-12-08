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
    
    private var tabbarVc: BaseTabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        boardInfo()
        notiChangeVc()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LaunchViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
}


extension AppDelegate {
    
    private func boardInfo() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    private func notiChangeVc() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootVc), name: NSNotification.Name("changeRootVc"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toOrderVc), name: NSNotification.Name("toOrderVc"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toLoginVc), name: NSNotification.Name("toLoginVc"), object: nil)
    }
    
    @objc private func changeRootVc() {
        tabbarVc = BaseTabBarController()
        window?.rootViewController = tabbarVc
    }
    
    @objc private func toOrderVc() {
        tabbarVc?.selectedIndex = 1
    }
    
    @objc private func toLoginVc() {
        window?.rootViewController = BaseNavigationController(rootViewController: LoginViewController())
    }
    
}
