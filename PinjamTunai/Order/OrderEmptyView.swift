//
//  OrderEmptyView.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
//

import UIKit
import SnapKit

class OrderEmptyView: UIView {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "image_empty_image")
        return bgImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = UIColor(hex: "#B4B4B4")
        oneLabel.textAlignment = .center
        oneLabel.text = LanguageManager.localizedString(for: "This page is empty")
        oneLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textColor = UIColor(hex: "#6D95FC")
        twoLabel.textAlignment = .center
        twoLabel.text = LanguageManager.localizedString(for: "Apply")
        twoLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        twoLabel.isUserInteractionEnabled = true
        return twoLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hex: "#6D95FC")
        lineView.layer.cornerRadius = 1
        lineView.layer.masksToBounds = true
        return lineView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(oneLabel)
        addSubview(twoLabel)
        addSubview(lineView)
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.size.equalTo(CGSize(width: 90, height: 90))
        }
        oneLabel.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(1)
        }
        twoLabel.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(40)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(twoLabel)
            make.height.equalTo(1)
            make.top.equalTo(twoLabel.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
