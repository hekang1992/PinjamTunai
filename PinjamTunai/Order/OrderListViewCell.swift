//
//  OrderListViewCell.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/10.
//

import UIKit
import SnapKit

class OrderListViewCell: UITableViewCell {
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 10
        whiteView.layer.masksToBounds = true
        return whiteView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335, height: 160))
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
