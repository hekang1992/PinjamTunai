//
//  FaceViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/8.
//

import UIKit
import SnapKit
import TYAlertController

class FaceViewController: BaseViewController {
    
    var productID: String = ""
    
    var modelArray: [midModel] = []
    
    var stepArray: [StepModel] = []
    
    let viewModel = FaceViewModel()
    
    var model: BaseModel?
    
    lazy var faceView: FaceView = {
        let faceView = FaceView()
        return faceView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        view.addSubview(faceView)
        
        headView.nameLabel.text = LanguageManager.localizedString(for: "Identity Information")
        
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
            stepArray.append(StepModel(title: "\(index + 1)", isCurrent: index == 0))
        }
        stepView.modelArray = stepArray
        
        
        faceView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        faceView.oneView.uploadBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            popModelView(with: model)
        }
        
        faceView.twoView.uploadBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            popModelView(with: model)
        }
        
        faceView.nextBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            popModelView(with: model)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getFaceInfo()
        }
    }
    
}

extension FaceViewController {
    
    private func getFaceInfo() async {
        Task {
            do {
                let json = ["shot": productID]
                let model = try await viewModel.faceMessageInfo(json: json)
                if model.token == 0 {
                    self.model = model
                    popModelView(with: model)
                }
            } catch {
                
            }
        }
    }
    
    private func popModelView(with model: BaseModel) {
        let lie = model.kindness?.above?.lie ?? ""
        let upturned = model.kindness?.above?.upturned ?? ""
        let code = LanguageManager.getLanguageCode()
        if lie.isEmpty {
            let imageStr = code == "2" ? "id_card_ili_image" : "card_ili_image"
            let popCardView = PopFaceView(frame: self.view.bounds)
            popCardView.bgImageView.image = UIImage(named: imageStr)
            let alertVc = TYAlertController(alert: popCardView, preferredStyle: .alert)!
            self.present(alertVc, animated: true)
            
            // upload---Image
            popCardView.oneBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    
                }
            }
            
            popCardView.twoBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            
            return
        }
        
        
        
    }
    
}
