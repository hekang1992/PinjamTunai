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
        
    }
    
}

extension LoginViewController {
    
    private func getCodeInfo() {
        let phone = self.loginView.phoneTextFiled.text ?? ""
        if phone.isEmpty {
            Toaster.showMessage(with: "Please Enter Your Phone Number")
            return
        }
        Task {
            do {
                let json = ["lose": phone]
                let model = try await viewModel.getCodeInfo(json: json)
                if model.token == 0 {
                    
                }
                Toaster.showMessage(with: model.stretched ?? "")
            } catch {
                
            }
        }
    }
    
    private func getVoiceCodeInfo() {
        let phone = self.loginView.phoneTextFiled.text ?? ""
        if phone.isEmpty {
            Toaster.showMessage(with: "Please Enter Your Phone Number")
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
        let phone = self.loginView.phoneTextFiled.text ?? ""
        let code = self.loginView.codeTextFiled.text ?? ""
        let agree = self.loginView.oneBtn.isSelected
        self.loginView.phoneTextFiled.resignFirstResponder()
        self.loginView.codeTextFiled.resignFirstResponder()
        if phone.isEmpty {
            Toaster.showMessage(with: "Please Enter Your Phone Number")
            return
        }
        if code.isEmpty {
            Toaster.showMessage(with: "Please Enter Verification Code")
            return
        }
        if agree == false {
            Toaster.showMessage(with: "Please agreed to all the terms")
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
