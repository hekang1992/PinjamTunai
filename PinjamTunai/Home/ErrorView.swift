//
//  ErrorView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ErrorView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    let disposeBag = DisposeBag()
    
    var clickBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "erroe_i_image")
        return bgImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = LanguageManager.localizedString(for: "Network Connection Failure")
        oneLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor.init(hex: "#3F3F3F")
        return oneLabel
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle(LanguageManager.localizedString(for: "Try again"), for: .normal)
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        oneBtn.setTitleColor(.white, for: .normal)
        oneBtn.setBackgroundImage(UIImage(named: "tr_is_image"), for: .normal)
        oneBtn.adjustsImageWhenHighlighted = true
        return oneBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        addSubview(bgImageView)
        addSubview(oneLabel)
        addSubview(oneBtn)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.size.equalTo(CGSize(width: 154, height: 128))
        }
        
        oneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(5)
            make.height.equalTo(12)
        }
        
        oneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(57)
            make.size.equalTo(CGSize(width: 155, height: 39))
        }
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.clickBlock?()
        }).disposed(by: disposeBag)
        
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ErrorView {
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(hex: "#6D95FC").cgColor,
            UIColor(hex: "#FFFFFF").cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        bgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bgView.bounds
    }
    
}
