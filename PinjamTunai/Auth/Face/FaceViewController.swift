//
//  FaceViewController.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

import UIKit
import SnapKit
import TYAlertController
import Kingfisher

class FaceViewController: BaseViewController {
    
    var productID: String = ""
    
    var modelArray: [midModel] = []
    
    var stepArray: [StepModel] = []
    
    let viewModel = FaceViewModel()
    
    var model: BaseModel?
    
    let locationManager = AppLocationManager()
    
    let trackingViewModel = TrackingViewModel()
    
    var apptitle: String = ""
    
    lazy var faceView: FaceView = {
        let faceView = FaceView()
        return faceView
    }()
    
    var oneCardtime: String = ""
    
    var oneFacetime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        view.addSubview(faceView)
        
        headView.nameLabel.text = apptitle
        
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
            let lie = model.kindness?.above?.lie ?? ""
            let upturned = model.kindness?.above?.upturned ?? ""
            if !lie.isEmpty && !upturned.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }else {
                popModelView(with: model)
            }
        }
        
        Task {
            await self.getFaceInfo()
        }
        
        oneCardtime = String(Int(Date().timeIntervalSince1970))
        
        getLocation()
    }
    
    private func getLocation() {
        locationManager.getCurrentLocation { model in
            LocationManagerModel.shared.model = model
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
                    self.selectCardImage()
                }
            }
            
            popCardView.twoBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            return
        }
        
        faceView.oneView.twoImageView.kf.setImage(with: URL(string: lie))
        faceView.oneView.uploadBtn.backgroundColor = UIColor(hex: "#18B45F")
        faceView.oneView.uploadBtn.setTitle(LanguageManager.localizedString(for: "Finished"), for: .normal)
        
        if upturned.isEmpty {
            oneFacetime = String(Int(Date().timeIntervalSince1970))
            getLocation()
            let imageStr = code == "2" ? "id_face_ili_image" : "face_ili_image"
            let popCardView = PopFaceView(frame: self.view.bounds)
            popCardView.bgImageView.image = UIImage(named: imageStr)
            let alertVc = TYAlertController(alert: popCardView, preferredStyle: .alert)!
            self.present(alertVc, animated: true)
            
            // upload---Image---face
            popCardView.oneBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.selectFaceImage()
                }
            }
            
            popCardView.twoBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            return
        }
        
        faceView.twoView.twoImageView.kf.setImage(with: URL(string: upturned))
        faceView.twoView.uploadBtn.backgroundColor = UIColor(hex: "#18B45F")
        faceView.twoView.uploadBtn.setTitle(LanguageManager.localizedString(for: "Finished"), for: .normal)
        
    }
    
    private func selectCardImage() {
        SystemCameraManager.shared.onPhotoCaptured = { [weak self] image in
            if let self = self, let image = image {
                if let data = image.jpegData(compressionQuality: 0.3) {
                    self.uploadCardImage(with: data, heads: "11")
                }
            }
        }
        
        SystemCameraManager.shared.takePhoto(from: self, type: "1")
    }
    
    private func selectFaceImage() {
        SystemCameraManager.shared.onPhotoCaptured = { [weak self] image in
            if let self = self, let image = image {
                if let data = image.jpegData(compressionQuality: 0.3) {
                    self.uploadCardImage(with: data, heads: "10")
                }
            }
        }
        
        SystemCameraManager.shared.takePhoto(from: self, type: "2")
    }
    
    private func uploadCardImage(with data: Data, heads: String) {
        Task {
            do {
                let json = ["heads": heads, "blissful": "1"]
                let model = try await viewModel.uploadCardInfo(json: json, data: data)
                if model.token == 0 {
                    if heads == "11" {
                        let fixing = model.kindness?.fixing ?? 1
                        if fixing == 0 {
                            await self.getFaceInfo()
                            await self.tracktwoInfo()
                        }else if fixing == 1 {
                            cardSuccessView(with: model.kindness?.breast ?? [])
                        }
                    }else {
                        await self.getFaceInfo()
                        await self.trackthreeInfo()
                    }
                }else {
                    Toaster.showMessage(with: model.stretched ?? "")
                }
            } catch {
                
            }
        }
    }
    
    private func cardSuccessView(with modelArray: [breastModel]) {
        let cardView = PopCommonAlertView(frame: self.view.bounds)
        cardView.modelArray = modelArray
        let alertVc = TYAlertController(alert: cardView, preferredStyle: .actionSheet)!
        self.present(alertVc, animated: true)
        
        cardView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        cardView.confirmBlock = { [weak self] in
            guard let self = self else { return }
            let name = cardView.oneView.phoneTextFiled.text ?? ""
            let idStr = cardView.twoView.phoneTextFiled.text ?? ""
            let dateStr = cardView.threeView.phoneTextFiled.text ?? ""
            let json = ["wild": dateStr, "lime": idStr, "bore": name, "shot": productID]
            saveCardInfo(json: json)
        }
        
        cardView.threeView.clickBlock = { [weak self] time in
            guard let self = self else { return }
            let timeView = PopTimeView(frame: self.view.bounds)
            timeView.defaultDateString = time.isEmpty ? "12-12-2000" : time
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            window.addSubview(timeView)
            
            timeView.timeBlock = { time in
                cardView.threeView.phoneTextFiled.text = time
                timeView.defaultDateString = time
                timeView.removeFromSuperview()
            }
            timeView.cancelBlock = {
                timeView.removeFromSuperview()
            }
        }
    }
    
    private func saveCardInfo(json: [String: String]) {
        Task {
            do {
                let model = try await viewModel.saveCardInfo(json: json)
                if model.token == 0 {
                    self.dismiss(animated: true)
                    await self.getFaceInfo()
                    await self.tracktwoInfo()
                }else {
                    Toaster.showMessage(with: model.stretched ?? "")
                }
            } catch {
                
            }
        }
    }
    
    private func tracktwoInfo() async {
        Task {
            do {
                let locationModel = LocationManagerModel.shared.model
                let ajson = ["sure": "2",
                             "thereafter": locationModel?.thereafter ?? "",
                             "leading": locationModel?.leading ?? "",
                             "aelfrida": oneCardtime,
                             "hair": String(Int(Date().timeIntervalSince1970)),
                             "swear": ""]
                let _ = try await trackingViewModel.saveTrackingMessageIngo(json: ajson)
            } catch  {
                
            }
        }
        
    }
    
    private func trackthreeInfo() async {
        Task {
            do {
                let locationModel = LocationManagerModel.shared.model
                let ajson = ["sure": "3",
                             "thereafter": locationModel?.thereafter ?? "",
                             "leading": locationModel?.leading ?? "",
                             "aelfrida": oneFacetime,
                             "hair": String(Int(Date().timeIntervalSince1970)),
                             "swear": ""]
                let _ = try await trackingViewModel.saveTrackingMessageIngo(json: ajson)
            } catch  {
                
            }
        }
        
    }
    
}
