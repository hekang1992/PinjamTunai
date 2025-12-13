//
//  ProductAccViewCell.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/9.
//

import UIKit
import SnapKit
import Kingfisher

class ProductAccViewCell: UITableViewCell {
    
    var model: aboveModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.wind ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            
            nameLabel.text = model.bring ?? ""
            moneyLabel.text = model.throng ?? ""
            descLabel.text = model.wondrous ?? ""
            
            let typeStr = model.rushing ?? ""
            typeLabel.text = typeStr
            
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(hex: "#FDFDFD")
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(hex: "#6D95FC").cgColor
        return bgView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#3A3A3A")
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .left
        moneyLabel.textColor = UIColor.init(hex: "#6D95FC")
        moneyLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(700))
        return moneyLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.textColor = UIColor.init(hex: "#B4B4B4")
        descLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        return descLabel
    }()
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.init(hex: "#FFFFFF")
        typeLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        return typeLabel
    }()
    
    lazy var typeView: UIView = {
        let typeView = UIView()
        typeView.backgroundColor = UIColor.init(hex: "#6D95FC")
        typeView.layer.cornerRadius = 15
        typeView.layer.masksToBounds = true
        return typeView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(moneyLabel)
        bgView.addSubview(descLabel)
        bgView.addSubview(typeView)
        typeView.addSubview(typeLabel)
        
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 335, height: 85))
            make.bottom.equalToSuperview().offset(-2)
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(4)
            make.height.equalTo(15)
        }
        moneyLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(logoImageView.snp.bottom).offset(8)
            make.height.equalTo(24)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(moneyLabel.snp.bottom).offset(1)
            make.height.equalTo(24)
        }
        typeView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-14)
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(80)
        }
        typeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
