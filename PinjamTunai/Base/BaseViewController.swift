//
//  BaseViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var headView: AppHeadView = {
        let headView = AppHeadView()
        return headView
    }()
    
    lazy var leaveView: PopSLeaveView = {
        let leaveView = PopSLeaveView()
        return leaveView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "#F2F4FA")
    }

}

extension BaseViewController {
    
    func backToListPageVc() {
        guard let navigationController = self.navigationController else { return }
        if let targetVC = navigationController.viewControllers.first(where: { $0 is AuthListViewController }) {
            navigationController.popToViewController(targetVC, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func popToLoginVc() {
        let naeVc = BaseNavigationController(rootViewController: LoginViewController())
        naeVc.modalPresentationStyle = .overFullScreen
        self.present(naeVc, animated: true)
    }
    
}
