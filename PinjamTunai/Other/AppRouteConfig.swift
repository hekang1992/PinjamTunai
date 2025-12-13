//
//  AppRouteConfig.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

import UIKit

let scheme_url = "ios://Pinj.amTu.nai"
let scheme_url_setting = "ios://Pinj.amTu.nai/is"
let scheme_url_home = "ios://Pinj.amTu.nai/thicket"
let scheme_url_login = "ios://Pinj.amTu.nai/the"
let scheme_url_order = "ios://Pinj.amTu.nai/this"
let scheme_url_detail = "ios://Pinj.amTu.nai/grew"

class AppRouteConfig {
    
    static func handleRoute(pageUrl: String, viewController: BaseViewController) {
        if pageUrl.contains(scheme_url_setting) {
            let settingVc = SettingViewController()
            viewController.navigationController?.pushViewController(settingVc, animated: true)
        }else if pageUrl.contains(scheme_url_home) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
            }
        }else if pageUrl.contains(scheme_url_login) {
            LoginConfig.deleteLoginInfo()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                NotificationCenter.default.post(name: NSNotification.Name("toLoginVc"), object: nil)
            }
        }else if pageUrl.contains(scheme_url_order) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                NotificationCenter.default.post(name: NSNotification.Name("toOrderVc"), object: nil)
            }
        }else if pageUrl.contains(scheme_url_detail) {
            let authListVc = AuthListViewController()
            let json = URLQueryParameterExtractor.extractAllParameters(from: pageUrl)
            authListVc.productID = json["shot"] ?? ""
            viewController.navigationController?.pushViewController(authListVc, animated: true)
        }else {
            
        }
    }
    
}

class URLQueryParameterExtractor {
    
    static func extractAllParameters(from urlString: String) -> [String: String] {
        guard let urlComponents = URLComponents(string: urlString),
              let queryItems = urlComponents.queryItems else {
            return [:]
        }
        
        var parameters: [String: String] = [:]
        queryItems.forEach { item in
            parameters[item.name] = item.value ?? ""
        }
        
        return parameters
    }
}
