//
//  LaunchViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit
import SnapKit

class LaunchViewController: BaseViewController {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_launch_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var againBtn: UIButton = {
        let againBtn = UIButton(type: .custom)
        againBtn.setTitle("Try Again", for: .normal)
        againBtn.setTitleColor(UIColor.init(hex: "#6D95FC"), for: .normal)
        againBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(500))
        return againBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(againBtn)
        againBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 120, height: 40))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        initAppInfo()
        
    }
    
}


extension LaunchViewController {
    
    private func initAppInfo() {
        let became = Locale.preferredLanguages.first ?? ""
        let famous = HTTPProxyInfo.proxyStatus.rawValue
        let fellowship = HTTPProxyInfo.vpnStatus.rawValue
        let dict = ["became": became, "famous": famous, "fellowship": fellowship] as [String : Any]
        Task {
            do {
                let model: BaseModel = try await HttpRequestManager.shared.get("/ecutiveof/became", parameters: dict)
            } catch {
            
            }
        }
    }
    
}


struct HTTPProxyInfo {
    
    enum ConnectionStatus: Int {
        case inactive = 0
        case active = 1
    }
    
    static var proxyStatus: ConnectionStatus {
        guard let settings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? [String: Any] else {
            return .inactive
        }
        return ((settings["HTTPProxy"] as? String ?? "").isEmpty &&
                (settings["HTTPSProxy"] as? String ?? "").isEmpty) ? .inactive : .active
    }
    
    static var vpnStatus: ConnectionStatus {
        guard let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
              let scopes = settings["__SCOPED__"] as? [String: Any] else {
            return .inactive
        }
        return scopes.keys.contains { $0.contains("tap") || $0.contains("tun") ||
                                      $0.contains("ppp") || $0.contains("ipsec") ||
                                      $0.contains("utun") } ? .active : .inactive
    }
}
