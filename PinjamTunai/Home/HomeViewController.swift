//
//  HomeViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit
import SnapKit
import MJRefresh
import CoreLocation

class HomeViewController: BaseViewController {
    
    lazy var oneView: OneView = {
        let oneView = OneView()
        return oneView
    }()
    
    lazy var twoView: TwoView = {
        let twoView = TwoView()
        return twoView
    }()
    
    let homeViewModel = HomeViewModel()
    
    let locationManager = AppLocationManager()
    
    let uploadViewModel = UpLoadIDFAViewModel()
    
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
            self.homeAllApiMessageInfo()
        })
        
        self.oneView.mentBlock = { [weak self] pageUrl in
            guard let self = self else { return }
            if pageUrl.isEmpty {
                return
            }
            let webVc = WebsiteViewController()
            webVc.pageUrl = pageUrl
            self.navigationController?.pushViewController(webVc, animated: true)
        }
        
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
            self.homeAllApiMessageInfo()
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
        self.homeAllApiMessageInfo()
    }
    
    private func homeAllApiMessageInfo() {
        Task { [weak self] in
            guard let self = self else { return }
            await homeMessageInfo()
            await appleInfo()
        }
        
        locationManager.getCurrentLocation { [weak self] model in
            guard let self = self else { return }
            guard let model = model else {
                let kissed = LanguageManager.getLanguageCode()
                if kissed == "2" {
                    if LoginConfig.hasValidToken() {
                        LocationPermissionAlert.show(on: self)
                    }
                }
                Task {
                    await self.appMacInfo()
                }
                return
            }
            LocationManagerModel.shared.model = model
            Task {
                await self.spoMessageInfo(with: model)
                await self.appMacInfo()
            }
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
        self.oneView.affModel = model.kindness?.affright
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
        
        let status = CLLocationManager().authorizationStatus
        
        
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

extension HomeViewController {
    
    private func spoMessageInfo(with model: LocationModel) async {
        Task {
            do {
                let json = ["story": model.story ?? "",
                            "jest": model.jest ?? "",
                            "meal": model.meal ?? "",
                            "followed": model.followed ?? "",
                            "leading": model.leading ?? "",
                            "thereafter": model.thereafter ?? "",
                            "afoot": model.afoot ?? "",
                            "drinking": model.drinking ?? ""]
                let _ = try await homeViewModel.uplocationMessageInfo(json: json)
            } catch {
            
            }
        }
    }
    
    private func appleInfo() async {
        
        uploadViewModel.onError = { msg in
            
        }
        
        uploadViewModel.onSuccess = { model in
            
        }
        
        let idfv = DeviceIdentifierManager.getIDFV() ?? ""
        
        let idfa = DeviceIdentifierManager.getIDFA() ?? ""
        
        let json = ["eating": idfv, "lovers": idfa]
        
        await uploadViewModel.uploadIDFAInfo(with: json)
    }
    
    private func appMacInfo() async {
        let bigJson = MacMessageConfig.bigJson
        
        guard let data = try? JSONSerialization.data(withJSONObject: bigJson,
                                                     options: [.prettyPrinted]),
              let jsonStr = String(data: data, encoding: .utf8) else {
            print("❌ JSON error=======")
            return
        }
        print("JSON=====✅=======\n\(jsonStr)")
        
        Task {
            do {
                let json = ["kindness": jsonStr]
                let _ = try await homeViewModel.upMacMessageInfo(json: json)
            } catch  {
                
            }
        }
        
    }

    
}
