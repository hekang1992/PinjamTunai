//
//  FaceListView.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FaceListView: UIView {
    
    let disposeBag = DisposeBag()
    
    var uploadBlock: (() -> Void)?
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 12
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var uploadBtn: UIButton = {
        let uploadBtn = UIButton(type: .custom)
        uploadBtn.backgroundColor = UIColor.init(hex: "#6D95FC")
        uploadBtn.setTitleColor(.white, for: .normal)
        uploadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        uploadBtn.layer.cornerRadius = 8
        uploadBtn.layer.masksToBounds = true
        uploadBtn.setTitle(LanguageManager.localizedString(for: "Upload"), for: .normal)
        return uploadBtn
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        return twoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hex: "#939090")
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(300))
        return nameLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteView)
        addSubview(uploadBtn)
        
        whiteView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 176))
        }
        
        uploadBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(whiteView.snp.bottom).offset(18)
            make.size.equalTo(CGSize(width: 237, height: 36))
        }
        
        whiteView.addSubview(oneImageView)
        whiteView.addSubview(twoImageView)
        whiteView.addSubview(nameLabel)
        oneImageView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(14)
            make.size.equalTo(CGSize(width: 96, height: 62))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(twoImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25)
        }
        
        uploadBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.uploadBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
