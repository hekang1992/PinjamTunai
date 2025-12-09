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

class RelationViewController: BaseViewController {
    
    var productID: String = ""
    
    let viewModel = RelationViewModel()
    
    var modelArray: [midModel] = []
    
    var stepArray: [StepModel] = []
    
    var model = BehaviorRelay<BaseModel?>(value: nil)
    
    let disposeBag = DisposeBag()
    
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
                    
                }
                return cell
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await getListInfo()
        }
    }
    
}

extension RelationViewController {
    
    private func saveBasicInfo(with json: [String: String]) async {
        Task {
            do {
                let model = try await viewModel.saveRelationInfo(json: json)
                if model.token == 0 {
                    self.navigationController?.popViewController(animated: true)
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
    
}
