//
//  AuthListViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/8.
//

import UIKit
import SnapKit
import MJRefresh
import RxSwift
import RxCocoa

class AuthListViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    var productID: String = ""
    
    let viewModel = AuthListViewModel()
    
    var droppedModel: droppedModel?
    
    var modelArray: [midModel]?
    
    var model: BaseModel?
    
    let locationManager = AppLocationManager()
    
    let trackingViewModel = TrackingViewModel()
    
    lazy var listView: AuthListView = {
        let listView = AuthListView()
        return listView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        headView.backBlock = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.listView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.refreshMessageInfo()
            }
        })
        
        self.listView.cellBlock = { [weak self] model in
            guard let self = self else { return }
            let stillness = String(model.stillness ?? 0)
            let blossoming = model.blossoming ?? ""
            dueBlossoming(with: blossoming, complete: stillness)
        }
        
        self.listView.nextBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            if let model = droppedModel {
                let blossoming = model.blossoming ?? ""
                dueBlossoming(with: blossoming, complete: "2")
            }else {
                // order-to-h5
                let lea = self.model?.kindness?.pavement?.lea ?? ""
                let beauty = self.model?.kindness?.pavement?.beauty ?? ""
                let stands = self.model?.kindness?.pavement?.stands ?? 0
                let pallid = self.model?.kindness?.pavement?.pallid ?? 0
                let json = ["lea": lea,
                            "beauty": beauty,
                            "stands": stands,
                            "pallid": pallid] as [String: Any]
                Task {
                    await self.reallyApplyProduct(with: json)
                }
            }
        }).disposed(by: disposeBag)
        
        
        locationManager.getCurrentLocation { model in
            LocationManagerModel.shared.model = model
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await refreshMessageInfo()
        }
    }
    
}

extension AuthListViewController {
    
    private func reallyApplyProduct(with json: [String: Any]) async {
        Task {
            do {
                let model = try await viewModel.reallyOrderInfo(json: json)
                if model.token == 0 {
                    let webVc = WebsiteViewController()
                    webVc.pageUrl = model.kindness?.whistling ?? ""
                    self.navigationController?.pushViewController(webVc, animated: true)
                    await self.trackeiggmesageInfo(with: json["lea"] as? String ?? "")
                }else {
                    Toaster.showMessage(with: model.stretched ?? "")
                }
            } catch {
                
            }
        }
    }
    
    private func refreshMessageInfo() async {
        Task {
            do {
                let dict = ["shot": productID]
                let model = try await viewModel.productDetailInfo(json: dict)
                if model.token == 0 {
                    self.model = model
                    self.listView.model = model
                    self.droppedModel = model.kindness?.dropped
                    self.modelArray = model.kindness?.mid ?? []
                    self.headView.nameLabel.text = model.kindness?.pavement?.silently ?? ""
                }
                self.listView.tableView.reloadData()
                await self.listView.tableView.mj_header?.endRefreshing()
            } catch {
                await self.listView.tableView.mj_header?.endRefreshing()
            }
        }
    }
    
    private func dueBlossoming(with type: String, complete: String? = "") {
        if complete == "2" {
            goPageVc(with: type)
        }else if complete == "0" { // false
            let blossoming = self.droppedModel?.blossoming ?? ""
            goPageVc(with: blossoming)
        }else if complete == "1" { // true
            goPageVc(with: type)
        }else {
            
        }
    }
    
    private func goPageVc(with type: String) {
        if type == "isa" {
            let faceVc = FaceViewController()
            faceVc.productID = productID
            faceVc.modelArray = self.modelArray ?? []
            self.navigationController?.pushViewController(faceVc, animated: true)
        }else if type == "isb" {
            let basicVc = BasicViewController()
            basicVc.productID = productID
            basicVc.modelArray = self.modelArray ?? []
            self.navigationController?.pushViewController(basicVc, animated: true)
        }else if type == "isc" {
            let workerVc = WorkerViewController()
            workerVc.productID = productID
            workerVc.modelArray = self.modelArray ?? []
            self.navigationController?.pushViewController(workerVc, animated: true)
        }else if type == "isd" {
            let relationVc = RelationViewController()
            relationVc.productID = productID
            relationVc.modelArray = self.modelArray ?? []
            self.navigationController?.pushViewController(relationVc, animated: true)
        }else if type == "ise" {
            let recVc = ReceiptAccountViewController()
            recVc.productID = productID
            recVc.modelArray = self.modelArray ?? []
            self.navigationController?.pushViewController(recVc, animated: true)
        }else {
            
        }
    }
    
    private func trackeiggmesageInfo(with swear: String) async {
        Task {
            do {
                let locationModel = LocationManagerModel.shared.model
                let ajson = ["sure": "8",
                             "thereafter": locationModel?.thereafter ?? "",
                             "leading": locationModel?.leading ?? "",
                             "aelfrida": String(Int(Date().timeIntervalSince1970)),
                             "hair": String(Int(Date().timeIntervalSince1970)),
                             "swear": swear]
                let _ = try await trackingViewModel.saveTrackingMessageIngo(json: ajson)
            } catch  {
                
            }
        }
    }
    
}
