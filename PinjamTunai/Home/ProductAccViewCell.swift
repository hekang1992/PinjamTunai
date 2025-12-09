//
//  ProductAccViewCell.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/9.
//

import UIKit
import SnapKit

class ProductAccViewCell: UITableViewCell {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(hex: "#FDFDFD")
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(hex: "#6D95FC").cgColor
        return bgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 335, height: 85))
            make.bottom.equalToSuperview().offset(-2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
