//
//  PopSettingView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/8.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopSettingView: UIView {
    
    let disposeBag = DisposeBag()
    
    var oneBlock: (() -> Void)?
    var twoBlock: (() -> Void)?

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        let code = LanguageManager.getLanguageCode()
        let imageStr = code == "2" ? "id_our_po_image" : "our_po_image"
        bgImageView.image = UIImage(named: imageStr)
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle(LanguageManager.localizedString(for: "Cancel"), for: .normal)
        oneBtn.backgroundColor = UIColor.init(hex: "#6D95FC")
        oneBtn.setTitleColor(.white, for: .normal)
        oneBtn.layer.cornerRadius = 25
        oneBtn.layer.masksToBounds = true
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle(LanguageManager.localizedString(for: "Log Out"), for: .normal)
        twoBtn.setTitleColor(UIColor.init(hex: "#989898"), for: .normal)
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return twoBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor(hex: "#525252")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = LanguageManager.localizedString(for: "Your account security is guaranteed after logging out. You can log in directly with your mobile phone number if you need to use the service again.")
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(twoBtn)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 336, height: 331))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(119)
        }
        oneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 256, height: 50))
            make.top.equalTo(nameLabel.snp.bottom).offset(38)
        }
        twoBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 256, height: 20))
            make.top.equalTo(oneBtn.snp.bottom).offset(13)
        }
        
        oneBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.oneBlock?()
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.twoBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
