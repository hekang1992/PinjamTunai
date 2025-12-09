//
//  HomeViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit
import SnapKit
import MJRefresh

class HomeViewController: BaseViewController {
    
    let homeViewModel = HomeViewModel()
    
    lazy var oneView: OneView = {
        let oneView = OneView()
        return oneView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.oneView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.homeMessageInfo()
            }
        })
        
        self.oneView.applyBlock = { [weak self] productID in
            guard let self = self else { return }
            if LoginConfig.hasValidToken() {
                self.applyProduct(with: productID)
            }else {
                let loginVc = BaseNavigationController(rootViewController: LoginViewController())
                loginVc.modalPresentationStyle = .overFullScreen
                self.present(loginVc, animated: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await homeMessageInfo()
            await threeCityInfo()
        }
    }

}

extension HomeViewController {
    
    private func homeMessageInfo() async {
        Task {
            do {
                let model = try await homeViewModel.homeMessageInfo()
                if model.token == 0 {
                    dueModel(with: model)
                }
                endRefreshing()
            } catch {
                endRefreshing()
            }
        }
    }
    
    private func threeCityInfo() async {
        Task {
            do {
                let model = try await homeViewModel.cityInfo()
                if model.token == 0 {
//                    dueModel(with: model)
                }
            } catch {
                
            }
        }
    }
    
    private func endRefreshing() {
        self.oneView.scrollView.mj_header?.endRefreshing()
    }
    
    // Judge One Two
    private func dueModel(with model: BaseModel) {
        model.kindness?.flew?.forEach { model in
            let heads = model.heads ?? ""
            if heads == "asb" {
                self.oneView.model = model.above?.first
            }
        }
    }
    
    // apply product
    private func applyProduct(with productID: String) {
        Task {
            do {
                let json = ["shot": productID]
                let model = try await homeViewModel.applyProductInfo(json: json)
                if model.token == 0 {
                    let whistling = model.kindness?.whistling ?? ""
                    self.goNextPage(with: whistling)
                }else {
                    Toaster.showMessage(with: model.stretched ?? "")
                }
            } catch {
            
            }
        }
    }
    
    private func goNextPage(with pageUrl: String) {
        if pageUrl.contains(scheme_url) {
            AppRouteConfig.handleRoute(pageUrl: pageUrl, viewController: self)
        }
    }
    
}
