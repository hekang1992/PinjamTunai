//
//  TwoView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

import UIKit
import SnapKit

class TwoView: UIView {

    lazy var bgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

