//
//  SettingViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/8.
//

import UIKit
import SnapKit
import TYAlertController

class SettingViewController: BaseViewController {
    
    let viewModel = SettingViewModel()
    
    lazy var settingView: SettingView = {
        let settingView = SettingView()
        return settingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        headView.nameLabel.text = LanguageManager.localizedString(for: "Set Up")
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        headView.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(settingView)
        settingView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        
        tapClick()
    }

}

extension SettingViewController {
    
    private func tapClick() {
        
        settingView.oneBlock = { [weak self] in
            guard let self = self else { return }
            let logoutView = PopSettingView(frame: self.view.bounds)
            let alertVc = TYAlertController(alert: logoutView, preferredStyle: .alert)!
            self.present(alertVc, animated: true)
            
            logoutView.oneBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            
            logoutView.twoBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    Task {
                        do {
                            let model = try await self.viewModel.logoutInfo()
                            if model.token == 0 {
                                LoginConfig.deleteLoginInfo()
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
            
        }
        
        settingView.twoBlock = { [weak self] in
            guard let self = self else { return }
            let deleAccView = PopDelAccView(frame: self.view.bounds)
            let alertVc = TYAlertController(alert: deleAccView, preferredStyle: .alert)!
            self.present(alertVc, animated: true)
            
            deleAccView.oneBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            
            deleAccView.twoBlock = { [weak self] in
                guard let self = self else { return }
                if deleAccView.clickBtn.isSelected == false {
                    Toaster.showMessage(with: LanguageManager.localizedString(for: "Please confirm the agreement"))
                    return
                }
                self.dismiss(animated: true) {
                    Task {
                        do {
                            let model = try await self.viewModel.deleaccInfo()
                            if model.token == 0 {
                                LoginConfig.deleteLoginInfo()
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
            
        }
        
    }
    
}
