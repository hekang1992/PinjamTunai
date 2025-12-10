//
//  BasicViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/9.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift
import RxCocoa
import TYAlertController

class BasicViewController: BaseViewController {
    
    var productID: String = ""
    
    let viewModel = BasicViewModel()
    
    var modelArray: [midModel] = []
    
    var stepArray: [StepModel] = []
    
    var model = BehaviorRelay<BaseModel?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    let locationManager = AppLocationManager()
    
    let trackingViewModel = TrackingViewModel()
    
    var onetime: String = ""
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle(LanguageManager.localizedString(for: "Next"), for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "home_apply_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: "BasicTableViewCell")
        tableView.register(TapTableViewCell.self, forCellReuseIdentifier: "TapTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        
        headView.nameLabel.text = LanguageManager.localizedString(for: "Base Information")
        
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        headView.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let stepView = StepIndicatorView()
        view.addSubview(stepView)
        
        stepView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(15)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
        }
        
        for (index, _) in modelArray.enumerated() {
            stepArray.append(StepModel(title: "\(index + 1)", isCurrent: (index < 2)))
        }
        stepView.modelArray = stepArray
        
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 313, height: 50))
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-20)
        }
        
        
        self.model
            .asObservable()
            .map { $0?.kindness?.ground ?? [] }
            .bind(to: tableView.rx.items) { tableView, row, model in
                let snow = model.snow ?? ""
                if snow == "birdb" {
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: "BasicTableViewCell",
                        for: IndexPath(row: row, section: 0)
                    ) as! BasicTableViewCell
                    cell.model = model
                    cell.textBlock = { text in
                        model.winds = text
                        model.heads = text
                    }
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: "TapTableViewCell",
                        for: IndexPath(row: row, section: 0)
                    ) as! TapTableViewCell
                    cell.model = model
                    cell.clickBlock = { [weak self] in
                        guard let self = self else { return }
                        self.view.endEditing(true)
                        popOneModel(with: model, cell: cell)
                    }
                    return cell
                }
            }
            .disposed(by: disposeBag)
                
        nextBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            var json = ["shot": productID]
            let modelArray = self.model.value?.kindness?.ground ?? []
            for (_, model) in modelArray.enumerated() {
                let key = model.token ?? ""
                json[key] = model.heads ?? ""
            }
            print("json======\(json)")
            
            Task {
                await self.saveBasicInfo(with: json)
            }
            
        }).disposed(by: disposeBag)
        
        Task {
            await getListInfo()
        }
        
        locationManager.getCurrentLocation { model in
            LocationManagerModel.shared.model = model
        }
        
        onetime = String(Int(Date().timeIntervalSince1970))
        
    }
    
}

extension BasicViewController {
    
    private func saveBasicInfo(with json: [String: String]) async {
        Task {
            do {
                let model = try await viewModel.saveBasicInfo(json: json)
                if model.token == 0 {
                    self.navigationController?.popViewController(animated: true)
                    await self.trackfmesageInfo()
                }
                Toaster.showMessage(with: model.stretched ?? "")
            } catch {
            
            }
        }
    }
    
    private func popOneModel(with model: groundModel, cell: TapTableViewCell) {
        let oneView = PopOneView(frame: self.view.bounds)
        let modelArray = model.breeze ?? []
        oneView.nameLabel.text = model.shrank ?? ""
        for (index, model) in modelArray.enumerated() {
            let text = cell.phoneTextFiled.text ?? ""
            let target = model.bore ?? ""
            if target == text {
                oneView.selectedIndex = index
            }
            oneView.modelArray = modelArray
        }
        
        let alertVc = TYAlertController(alert: oneView, preferredStyle: .actionSheet)!
        self.present(alertVc, animated: true)
        
        oneView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        oneView.confirmBlock = { [weak self] amodel in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                cell.phoneTextFiled.text = amodel.bore ?? ""
                model.winds = amodel.bore ?? ""
                model.heads = amodel.heads ?? ""
            }
        }
    }
    
    private func getListInfo() async {
        Task {
            do {
                let json = ["shot": productID]
                let model = try await viewModel.getBasicInfo(json: json)
                if model.token == 0 {
                    self.model.accept(model)
                }
            } catch  {
                
            }
        }
    }
    
    private func trackfmesageInfo() async {
        Task {
            do {
                let locationModel = LocationManagerModel.shared.model
                let ajson = ["sure": "4",
                             "thereafter": locationModel?.thereafter ?? "",
                             "leading": locationModel?.leading ?? "",
                             "aelfrida": onetime,
                             "hair": String(Int(Date().timeIntervalSince1970)),
                             "swear": ""]
                let _ = try await trackingViewModel.saveTrackingMessageIngo(json: ajson)
            } catch  {
                
            }
        }
    }
    
}
