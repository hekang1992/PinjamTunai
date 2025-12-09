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
    
    lazy var twoView: TwoView = {
        let twoView = TwoView()
        return twoView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(twoView)
        twoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        oneView.isHidden = true
        twoView.isHidden = true
        
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
                let naeVc = BaseNavigationController(rootViewController: LoginViewController())
                naeVc.modalPresentationStyle = .overFullScreen
                self.present(naeVc, animated: true)
            }
        }
        
        self.twoView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.homeMessageInfo()
            }
        })
        
        self.twoView.applyBlock = { [weak self] productID in
            guard let self = self else { return }
            if LoginConfig.hasValidToken() {
                self.applyProduct(with: productID)
            }else {
                let naeVc = BaseNavigationController(rootViewController: LoginViewController())
                naeVc.modalPresentationStyle = .overFullScreen
                self.present(naeVc, animated: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await homeMessageInfo()
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
    
    private func endRefreshing() {
        self.oneView.scrollView.mj_header?.endRefreshing()
        self.twoView.tableView.mj_header?.endRefreshing()
    }
    
    // Judge One Two
    private func dueModel(with model: BaseModel) {
        model.kindness?.flew?.forEach { model in
            let heads = model.heads ?? ""
            if heads == "asb" {
                oneView.isHidden = false
                twoView.isHidden = true
                self.oneView.model = model.above?.first
            }else if heads == "asc" || heads == "asd" {
                oneView.isHidden = true
                twoView.isHidden = false
                if heads == "asc" {
                    self.twoView.model = model.above?.first
                }
                
                if heads == "asd" {
                    self.twoView.modelArray = model.above
                }
                
                self.twoView.tableView.reloadData()
            }else {
                
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
        }else {
            let webVc = WebsiteViewController()
            webVc.pageUrl = pageUrl
            self.navigationController?.pushViewController(webVc, animated: true)
        }
    }
    
}
