//
//  PopSLeaveView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopSLeaveView: UIView {
    
    let disposeBag = DisposeBag()
    
    var oneBlock: (() -> Void)?
    var twoBlock: (() -> Void)?

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        let code = LanguageManager.getLanguageCode()
        let imageStr = code == "2" ? "id_lea_li_image" : "lea_li_image"
        bgImageView.image = UIImage(named: imageStr)
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle(LanguageManager.localizedString(for: "Continue"), for: .normal)
        oneBtn.backgroundColor = UIColor.init(hex: "#6D95FC")
        oneBtn.setTitleColor(.white, for: .normal)
        oneBtn.layer.cornerRadius = 25
        oneBtn.layer.masksToBounds = true
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle(LanguageManager.localizedString(for: "Leave"), for: .normal)
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
        nameLabel.text = LanguageManager.localizedString(for: "Your repayment record is exceptionally excellent! The system has upgraded your credit limit to 8.000.000, and the low-interest rate channel is open for a limited time—it would be a pity to miss it!")
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
            make.top.equalToSuperview().offset(103)
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
