//
//  OrderListViewCell.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
//

import UIKit
import SnapKit
import Kingfisher

class OrderListViewCell: UITableViewCell {
    
    var model: flewModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.wind ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.bring ?? ""
            typeLabel.text = model.rushing ?? ""
            
            coverListView(with: model.mournful ?? [])
        }
    }
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 10
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var lineView: DashedLineView = {
        let lineView = DashedLineView()
        return lineView
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
    
    lazy var typeView: UIView = {
        let typeView = UIView()
        typeView.backgroundColor = UIColor(hex: "#FFCC6C")
        typeView.layer.cornerRadius = 10
        typeView.layer.masksToBounds = true
        typeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        return typeView
    }()
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.init(hex: "#FFFFFF")
        typeLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(500))
        return typeLabel
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        return coverView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(whiteView)
        whiteView.addSubview(lineView)
        whiteView.addSubview(logoImageView)
        whiteView.addSubview(nameLabel)
        whiteView.addSubview(typeView)
        typeView.addSubview(typeLabel)
        whiteView.addSubview(coverView)
        
        whiteView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335.pix(), height: 160))
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(9)
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.left.equalToSuperview().offset(9)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(20)
        }
        typeView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(84)//min width
        }
        typeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.bottom.equalToSuperview()
        }
        coverView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OrderListViewCell {
    
    private func coverListView(with modelArray: [mournfulModel]) {
        coverView.subviews.forEach { $0.removeFromSuperview() }
        
        guard !modelArray.isEmpty else { return }
        
        var previousView: OrderMinListView?
        
        for (index, item) in modelArray.enumerated() {
            let listView = OrderMinListView()
            listView.model = item
            coverView.addSubview(listView)
            if index == 0 {
                listView.twoLabel.textColor = UIColor.init(hex: "#6D95FC")
                listView.twoLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(500))
            }else {
                listView.twoLabel.textColor = UIColor.init(hex: "#000000")
                listView.twoLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
            }
            
            listView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(28)
                
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(10)
                } else {
                    make.top.equalToSuperview().offset(10)
                }
                if index == modelArray.count - 1 {
                    make.bottom.lessThanOrEqualToSuperview().offset(-10)
                }
            }
            previousView = listView
        }
    }
    
}
