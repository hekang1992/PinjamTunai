//
//  LaunchViewController.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/6.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FBSDKCoreKit
import AppTrackingTransparency

class LaunchViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    var apiArray: [[String: String]] = []
    
    var index: Int = 0
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_launch_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var againBtn: UIButton = {
        let againBtn = UIButton(type: .custom)
        againBtn.setTitle(LanguageManager.localizedString(for: "Try Again"), for: .normal)
        againBtn.setTitleColor(UIColor.init(hex: "#6D95FC"), for: .normal)
        againBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(500))
        againBtn.isHidden = true
        return againBtn
    }()
    
    let viewModel = LaunchViewModel()
    let uploadViewModel = UpLoadIDFAViewModel()
    
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
        
        NetworkMonitor.shared.startMonitoring()
        
        NetworkMonitor.shared.networkTypeChanged = { [weak self] networkType in
            guard let self = self else { return }
            if networkType == "5G" || networkType == "WIFI" {
                Task { [weak self] in
                    guard let self = self else { return }
                    self.getJsonInfo()
                }
            }else {
                if UIDevice.current.model == "iPad" {
                    UserDefaults.standard.set("1", forKey: "kissed")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
                    }
                }
            }
        }
        
        againBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self else { return }
                Task { [weak self] in
                    guard let self else { return }
                    await self.initAppInfo()
                    await self.appleInfo()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    @MainActor
    deinit {
        print("LaunchViewController============")
    }
    
}


extension LaunchViewController {
    
    
    func getJsonInfo() {
        let pageUrl = "https://id08-dc.oss-ap-southeast-5.aliyuncs.com/pinjam-tunai/693b83f95a67a.json"
        guard let url = URL(string: pageUrl) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                return
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonArray = jsonObject as? [[String: String]] {
                    self.apiArray = jsonArray
                    Task {
                        await self.initAppInfo()
                    }
                }
            } catch {
                
            }
        }
        task.resume()
    }
    
    
    private func initAppInfo() async {
        LoadingView.show()
        let became = Locale.preferredLanguages.first ?? ""
        let famous = HTTPProxyInfo.proxyStatus.rawValue
        let fellowship = HTTPProxyInfo.vpnStatus.rawValue
        let dict = ["became": became,
                    "famous": famous,
                    "fellowship": fellowship] as [String : Any]
        
        viewModel.onError = { [weak self] msg in
            guard let self = self else { return }
            self.againBtn.isHidden = false
            print("Error: \(msg)")
            LoadingView.hide()
            
            
            if self.index > self.apiArray.count - 1 {
                return
            }
            
            let apiUrl = self.apiArray[self.index]["pt"] ?? ""
            UserDefaults.standard.set(apiUrl, forKey: "baseUrl")
            UserDefaults.standard.synchronize()
            
            self.index += 1
            Task {
                await self.initAppInfo()
            }
            
        }
        
        viewModel.onSuccess = { [weak self] model in
            LoadingView.hide()
            guard let self = self, let model = model else { return }
            if model.token == 0 {
                DispatchQueue.main.async {
                    self.againBtn.isHidden = true
                }
                var kissed = "1"
                if UIDevice.current.model == "iPad" {
                    kissed = "1"
                }else {
                    kissed = String(model.kindness?.kissed ?? 1)
                }
                let privacyPolicyUrl = model.kindness?.privacyPolicyUrl ?? ""
                UserDefaults.standard.set(kissed, forKey: "kissed")
                UserDefaults.standard.set(privacyPolicyUrl, forKey: "privacyPolicyUrl")
                UserDefaults.standard.synchronize()
                if let tModel = model.kindness?.toward {
                    self.fbInfo(with: tModel)
                }
                if let lang = AppLanguage(rawValue: kissed) {
                    LanguageManager.setLanguage(lang)
                }
                Task {
                    await self.getIDFAInfo()
                }
            }else {
                DispatchQueue.main.async {
                    self.againBtn.isHidden = false
                }
            }
        }
        await viewModel.initLaunchInfo(with: dict)
        
    }
    
    private func getIDFAInfo() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if #available(iOS 14.0, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .restricted:
                        break
                    case .authorized, .notDetermined, .denied:
                        Task { [weak self] in
                            guard let self = self else { return }
                            await self.appleInfo()
                        }
                        break
                    @unknown default:
                        break
                    }
                }
            }
        }
    }
    
    private func appleInfo() async {
        
        uploadViewModel.onError = { [weak self] msg in
            guard let self = self else { return }
            self.againBtn.isHidden = false
        }
        
        uploadViewModel.onSuccess = { [weak self] model in
            guard let self = self, let model = model else { return }
            if model.token == 0 {
                DispatchQueue.main.async {
                    self.againBtn.isHidden = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
                }
            }else {
                self.againBtn.isHidden = false
            }
        }
        
        let idfv = DeviceIdentifierManager.getDeviceIdentifier()
        let idfa = DeviceIdentifierManager.getIDFA() ?? ""
        let json = ["eating": idfv, "lovers": idfa]
        await uploadViewModel.uploadIDFAInfo(with: json)
    }
    
    private func fbInfo(with model: towardModel) {
        Settings.shared.appID = model.company ?? ""
        Settings.shared.clientToken = model.troth ?? ""
        Settings.shared.displayName = model.drawing ?? ""
        Settings.shared.appURLSchemeSuffix = model.feel ?? ""
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
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
