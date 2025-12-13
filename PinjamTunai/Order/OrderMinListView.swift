//
//  OrderMinListView.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
//

import UIKit
import SnapKit

class OrderMinListView: UIView {
    
    var model: mournfulModel? {
        didSet {
            guard let model = model else { return }
            oneLabel.text = model.shrank ?? ""
            twoLabel.text = model.fain ?? ""
        }
    }
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = UIColor(hex: "#B2AEAE")
        oneLabel.textAlignment = .left
        oneLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .right
        return twoLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneLabel)
        addSubview(twoLabel)
        
        oneLabel.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-21)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
