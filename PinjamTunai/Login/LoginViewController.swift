//
//  LoginViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    lazy var loginView: LoginView = {
        let loginView = LoginView(frame: .zero)
        return loginView
    }()
    
    private let viewModel = LoginViewModel()
    
    let locationManager = AppLocationManager()
    
    var aelfrida: String = ""
    
    var hair: String = ""
    
    private var countdownTimer: Timer?
    private var remainingSeconds = 60
    private var isCountingDown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginView.codeBlock = { [weak self] in
            guard let self = self else { return }
            getCodeInfo()
        }
        
        loginView.voiceBlock = { [weak self] in
            guard let self = self else { return }
            getVoiceCodeInfo()
        }
        
        loginView.loginBlock = { [weak self] in
            guard let self = self else { return }
            toLoginInfo()
        }
        
        loginView.mentBlock = { [weak self] in
            guard let self = self else { return }
            let webVc = WebsiteViewController()
            let privacyPolicyUrl = UserDefaults.standard.object(forKey: "privacyPolicyUrl") as? String ?? ""
            webVc.pageUrl = privacyPolicyUrl
            self.navigationController?.pushViewController(webVc, animated: true)
        }
        
        locationManager.getCurrentLocation { model in
            LocationManagerModel.shared.model = model
        }
        
        SaveTimeConfig.saveStartTime()
    }
    
    private func startCountdown() {
        if isCountingDown { return }
        
        isCountingDown = true
        remainingSeconds = 60
        
        loginView.codeBtn.isEnabled = false
        loginView.codeBtn.setTitle("60s", for: .disabled)
        loginView.codeBtn.setTitleColor(.white, for: .disabled)
        loginView.codeBtn.backgroundColor = UIColor.init(hex: "#6D95FC")
        
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCountdown),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func updateCountdown() {
        remainingSeconds -= 1
        if remainingSeconds > 0 {
            loginView.codeBtn.setTitle("\(remainingSeconds)s", for: .disabled)
        } else {
            stopCountdown()
        }
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isCountingDown = false
        
        // 恢复按钮状态
        loginView.codeBtn.isEnabled = true
        loginView.codeBtn.setTitle(LanguageManager.localizedString(for: "Get Code"), for: .normal)
        loginView.codeBtn.setTitleColor(.blue, for: .normal)
        loginView.codeBtn.backgroundColor = .white
    }
}

extension LoginViewController {
    
    private func getCodeInfo() {
        SaveTimeConfig.saveEndTime()
        let phone = self.loginView.phoneTextFiled.text ?? ""
        if phone.isEmpty {
            Toaster.showMessage(with: LanguageManager.localizedString(for: "Please Enter Your Phone Number"))
            return
        }
        Task {
            do {
                let json = ["lose": phone]
                let model = try await viewModel.getCodeInfo(json: json)
                if model.token == 0 {
                    startCountdown()
                }
                Toaster.showMessage(with: model.stretched ?? "")
            } catch {
                
            }
        }
    }
    
    private func getVoiceCodeInfo() {
        SaveTimeConfig.saveEndTime()
        let phone = self.loginView.phoneTextFiled.text ?? ""
        if phone.isEmpty {
            Toaster.showMessage(with: LanguageManager.localizedString(for: "Please Enter Your Phone Number"))
            return
        }
        Task {
            do {
                let json = ["lose": phone]
                let model = try await viewModel.getVoiceCodeInfo(json: json)
                if model.token == 0 {
                    
                }
                Toaster.showMessage(with: model.stretched ?? "")
            } catch {
                
            }
        }
    }
    
    private func toLoginInfo() {
        SaveTimeConfig.saveEndTime()
        let phone = self.loginView.phoneTextFiled.text ?? ""
        let code = self.loginView.codeTextFiled.text ?? ""
        let agree = self.loginView.oneBtn.isSelected
        self.loginView.phoneTextFiled.resignFirstResponder()
        self.loginView.codeTextFiled.resignFirstResponder()
        if phone.isEmpty {
            Toaster.showMessage(with: LanguageManager.localizedString(for: "Please Enter Your Phone Number"))
            return
        }
        if code.isEmpty {
            Toaster.showMessage(with: LanguageManager.localizedString(for: "Please Enter Verification Code"))
            return
        }
        if agree == false {
            Toaster.showMessage(with: LanguageManager.localizedString(for: "Please agree to all the terms"))
            return
        }
        Task {
            do {
                let json = ["drop": phone, "lest": code]
                let model = try await viewModel.toLoginInfo(json: json)
                if model.token == 0 {
                    let phone = model.kindness?.drop ?? ""
                    let token = model.kindness?.mill ?? ""
                    LoginConfig.saveLoginInfo(to: phone, token: token)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
                    }
                }
                Toaster.showMessage(with: model.stretched ?? "")
            } catch {
                
            }
        }
    }
    
}

class SaveTimeConfig {
    
    static func saveStartTime() {
        UserDefaults.standard.set(String(Int(Date().timeIntervalSince1970)), forKey: "aelfrida")
        UserDefaults.standard.synchronize()
    }
    
    static func saveEndTime() {
        UserDefaults.standard.set(String(Int(Date().timeIntervalSince1970)), forKey: "hair")
        UserDefaults.standard.synchronize()
    }
    
    static func getStartTime() -> String {
        let aelfrida = UserDefaults.standard.object(forKey: "aelfrida") as? String ?? ""
        return aelfrida
    }
    
    static func getEndTime() -> String {
        let hair = UserDefaults.standard.object(forKey: "hair") as? String ?? ""
        return hair
    }
    
    static func deleteAllTime() {
        UserDefaults.standard.removeObject(forKey: "aelfrida")
        UserDefaults.standard.removeObject(forKey: "hair")
        UserDefaults.standard.synchronize()
    }
}
