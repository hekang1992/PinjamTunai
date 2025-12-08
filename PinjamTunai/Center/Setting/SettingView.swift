//
//  SettingView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/8.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift
import RxCocoa

class SettingView: UIView {
    
    let disposeBag = DisposeBag()
    
    var oneBlock: (() -> Void)?
    var twoBlock: (() -> Void)?
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        oneView.layer.cornerRadius = 8
        oneView.layer.masksToBounds = true
        oneView.layer.borderWidth = 1
        oneView.layer.borderColor = UIColor.init(hex: "#AEC2FF").cgColor
        return oneView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "out_im_image")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "right_icon_image")
        return twoImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = LanguageManager.localizedString(for: "Log Out")
        oneLabel.textColor = UIColor.init(hex: "#2F2F2F")
        oneLabel.textAlignment = .left
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return oneLabel
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .white
        twoView.layer.cornerRadius = 8
        twoView.layer.masksToBounds = true
        twoView.layer.borderWidth = 1
        twoView.layer.borderColor = UIColor.init(hex: "#AEC2FF").cgColor
        twoView.alpha = 0.3
        return twoView
    }()
    
    lazy var one1ImageView: UIImageView = {
        let one1ImageView = UIImageView()
        one1ImageView.image = UIImage(named: "del_im_image")
        return one1ImageView
    }()
    
    lazy var two1ImageView: UIImageView = {
        let two1ImageView = UIImageView()
        two1ImageView.image = UIImage(named: "right_icon_image")
        return two1ImageView
    }()
    
    lazy var one1Label: UILabel = {
        let one1Label = UILabel()
        one1Label.text = LanguageManager.localizedString(for: "Delete")
        one1Label.textColor = UIColor.init(hex: "#2F2F2F")
        one1Label.textAlignment = .left
        one1Label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return one1Label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneView)
        oneView.addSubview(oneImageView)
        oneView.addSubview(twoImageView)
        oneView.addSubview(oneLabel)
        oneView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 48))
            make.top.equalToSuperview()
        }
        oneImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        oneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneImageView.snp.right).offset(6)
            make.height.equalTo(20)
        }
        twoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        addSubview(twoView)
        twoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 48))
            make.top.equalTo(oneView.snp.bottom).offset(18)
        }
        twoView.addSubview(one1ImageView)
        twoView.addSubview(two1ImageView)
        twoView.addSubview(one1Label)
        
        one1ImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        one1Label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(one1ImageView.snp.right).offset(6)
            make.height.equalTo(20)
        }
        two1ImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        oneView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.oneBlock?()
        }).disposed(by: disposeBag)
        
        twoView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.twoBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
