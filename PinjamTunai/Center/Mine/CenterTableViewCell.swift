//
//  CenterTableViewCell.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/8.
//

import UIKit
import SnapKit
import Kingfisher

class CenterTableViewCell: UITableViewCell {
    
    var model: flewModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.swan ?? ""
            iconImageView.kf.setImage(with: URL(string: logoUrl))
            
            nameLabel.text = model.shrank ?? ""
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .clear
        return bgView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.backgroundColor = .gray
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
        return iconImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#2F2F2F")
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "right_icon_image")
        return rightImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(rightImageView)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-11)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.height.equalTo(20)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
