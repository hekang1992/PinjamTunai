//
//  TwoHeadView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/9.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class TwoHeadView: UIView {
    
    var applyBlock: ((String) -> Void)?
    
    let disposeBag = DisposeBag()
    
    var model: aboveModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.wind ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.bring ?? ""
            let applyStr = model.rushing ?? ""
            applyBtn.setTitle(applyStr, for: .normal)
            oneLabel.text = model.wondrous ?? ""
            twoLabel.text = model.throng ?? ""
            
            let desc = model.among ?? ""
            let time = model.fixed ?? ""
            
            let desc1 = model.wreath ?? ""
            let time1 = model.samite ?? ""
            
            threeLabel.text = "\(desc): \(time)"
            fourLabel.text = "\(desc1): \(time1)"
        }
    }

    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 16
        whiteView.layer.masksToBounds = true
        whiteView.layer.shadowColor = UIColor.black.cgColor
        whiteView.layer.shadowOffset = CGSize(width: 0, height: 2)
        whiteView.layer.shadowOpacity = 0.1
        whiteView.layer.shadowRadius = 4
        return whiteView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.clipsToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor(hex: "#3D3D3D")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return nameLabel
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        applyBtn.setBackgroundImage(UIImage(named: "home_apply_image"), for: .normal)
        applyBtn.adjustsImageWhenHighlighted = false
        return applyBtn
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor(hex: "#6D95FC")
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .center
        twoLabel.textColor = UIColor(hex: "#6D95FC")
        twoLabel.font = UIFont.systemFont(ofSize: 55, weight: UIFont.Weight(500))
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textAlignment = .center
        threeLabel.textColor = UIColor(hex: "#C8C8C8")
        threeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textAlignment = .center
        fourLabel.textColor = UIColor(hex: "#C8C8C8")
        fourLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return fourLabel
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(whiteView)
        
        // Setup stackView
        whiteView.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(nameLabel)
        
        whiteView.addSubview(oneLabel)
        whiteView.addSubview(twoLabel)
        whiteView.addSubview(threeLabel)
        whiteView.addSubview(fourLabel)
        whiteView.addSubview(applyBtn)
        whiteView.addSubview(clickBtn)
        
        whiteView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(279)
        }
        
        // stackView constraints - 居中显示
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        // logoImageView constraints
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(12)
            make.height.equalTo(15)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(2)
            make.height.equalTo(63)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        threeLabel.snp.makeConstraints { make in
            make.top.equalTo(twoLabel.snp.bottom).offset(7)
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        fourLabel.snp.makeConstraints { make in
            make.top.equalTo(threeLabel.snp.bottom).offset(7)
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(fourLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 315, height: 55))
        }
        
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clickBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            let productID = String(self.model?.windows ?? 0)
            self.applyBlock?(productID)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
