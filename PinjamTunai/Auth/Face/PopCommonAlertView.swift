//
//  PopCommonAlertView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/9.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopCommonAlertView: UIView {
    
    var modelArray: [breastModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            
            oneView.nameLabel.text = modelArray[0].strain ?? ""
            oneView.phoneTextFiled.placeholder = modelArray[0].strain ?? ""
            
            twoView.nameLabel.text = modelArray[1].strain ?? ""
            twoView.phoneTextFiled.placeholder = modelArray[1].strain ?? ""
            
            threeView.nameLabel.text = modelArray[2].strain ?? ""
            threeView.phoneTextFiled.placeholder = modelArray[2].strain ?? ""
            
            oneView.phoneTextFiled.text = modelArray[0].lingering ?? ""
            
            twoView.phoneTextFiled.text = modelArray[1].lingering ?? ""
            
            threeView.phoneTextFiled.text = modelArray[2].lingering ?? ""
            
        }
    }
    
    let disposeBag = DisposeBag()
    
    var cancelBlock: (() -> Void)?
    
    var confirmBlock: (() -> Void)?

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "com_po_gb_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "can_c_ia_image"), for: .normal)
        return cancelBtn
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.setTitle(LanguageManager.localizedString(for: "Confirm"), for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        loginBtn.setBackgroundImage(UIImage(named: "home_apply_image"), for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        return loginBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hex: "#FFCC6C")
        lineView.layer.cornerRadius = 2
        lineView.layer.masksToBounds = true
        return lineView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = LanguageManager.localizedString(for: "Confirm Information")
        nameLabel.textColor = UIColor.init(hex: "#000000")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var oneView: PopListView = {
        let oneView = PopListView()
        oneView.clickBtn.isHidden = true
        oneView.iconImageView.isHidden = true
        return oneView
    }()
    
    lazy var twoView: PopListView = {
        let twoView = PopListView()
        twoView.clickBtn.isHidden = true
        twoView.iconImageView.isHidden = true
        return twoView
    }()
    
    lazy var threeView: PopListView = {
        let threeView = PopListView()
        threeView.clickBtn.isHidden = false
        threeView.iconImageView.isHidden = false
        return threeView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(loginBtn)
        bgImageView.addSubview(lineView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(oneView)
        bgImageView.addSubview(twoView)
        bgImageView.addSubview(threeView)
        
        bgImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(406)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 313, height: 50))
            make.bottom.equalToSuperview().offset(-30)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(55)
            make.size.equalTo(CGSize(width: 64, height: 4))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        
        oneView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 375, height: 60))
        }
        
        twoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneView.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: 375, height: 60))
        }
        
        threeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: 375, height: 60))
        }
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind(onNext: {  [weak self] in
            guard let self = self else { return }
            self.confirmBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
