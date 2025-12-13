//
//  AuthListViewCell.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

import UIKit
import SnapKit
import Kingfisher

class AuthListViewCell: UITableViewCell {
    
    var model: midModel? {
        didSet {
            guard let model = model else { return }
            
            let logoUrl = model.snowy ?? ""
            leftImageView.kf.setImage(with: URL(string: logoUrl))
            
            threeLabel.text = model.shrank ?? ""
            fourLabel.text = model.nestled ?? ""
            let stillness = model.stillness ?? 0
            if stillness == 1 {
                rightImageView.image = UIImage(named: "auth_list_comp_image")
            }else {
                rightImageView.image = UIImage(named: "auth_list_nor_image")
            }
            
            let blossoming = model.blossoming ?? ""
            
            switch blossoming {
            case "isa":
                listImageView.image = stillness == 1 ? UIImage(named: "one_com_type_image") : UIImage(named: "list_auth_nor_image")
                threeLabel.textColor = stillness == 1 ? UIColor.init(hex: "#608EFC") : UIColor.init(hex: "#ACACAC")
                break
            case "isb":
                listImageView.image = stillness == 1 ? UIImage(named: "two_com_type_image") : UIImage(named: "list_auth_nor_image")
                threeLabel.textColor = stillness == 1 ? UIColor.init(hex: "#FBA505") : UIColor.init(hex: "#ACACAC")
                break
            case "isc":
                listImageView.image = stillness == 1 ? UIImage(named: "three_com_type_image") : UIImage(named: "list_auth_nor_image")
                threeLabel.textColor = stillness == 1 ? UIColor.init(hex: "#22CB59") : UIColor.init(hex: "#ACACAC")
                break
            case "isd":
                listImageView.image = stillness == 1 ? UIImage(named: "four_com_type_image") : UIImage(named: "list_auth_nor_image")
                threeLabel.textColor = stillness == 1 ? UIColor.init(hex: "#855FFE") : UIColor.init(hex: "#ACACAC")
                break
            case "ise":
                listImageView.image = stillness == 1 ? UIImage(named: "five_com_type_image") : UIImage(named: "list_auth_nor_image")
                threeLabel.textColor = stillness == 1 ? UIColor.init(hex: "#60DAFC") : UIColor.init(hex: "#ACACAC")
                break
            default:
                break
            }
            
        }
    }

    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = "ITEM"
        oneLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor.init(hex: "#979797")
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.text = "01"
        twoLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(400))
        twoLabel.textAlignment = .center
        twoLabel.textColor = UIColor.init(hex: "#979797")
        return twoLabel
    }()
    
    lazy var listImageView: UIImageView = {
        let listImageView = UIImageView()
        listImageView.image = UIImage(named: "list_auth_nor_image")
        return listImageView
    }()
    
    lazy var leftImageView: UIImageView = {
        let leftImageView = UIImageView()
        leftImageView.layer.cornerRadius = 5
        leftImageView.layer.masksToBounds = true
        return leftImageView
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        threeLabel.textAlignment = .left
        threeLabel.textColor = UIColor.init(hex: "#ACACAC")
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.numberOfLines = 0
        fourLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(300))
        fourLabel.textAlignment = .left
        fourLabel.textColor = UIColor.init(hex: "#ACACAC")
        return fourLabel
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "auth_list_nor_image")
        return rightImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        bgView.addSubview(oneLabel)
        bgView.addSubview(twoLabel)
        bgView.addSubview(listImageView)
        bgView.addSubview(leftImageView)
        bgView.addSubview(rightImageView)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 85))
            make.bottom.equalToSuperview().offset(-15)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 67, height: 15))
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom)
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 67, height: 40))
        }
        
        listImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneLabel.snp.right)
            make.size.equalTo(CGSize(width: 4, height: 69))
        }
        leftImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(listImageView.snp.right).offset(10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        bgView.addSubview(threeLabel)
        bgView.addSubview(fourLabel)
        
        threeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.height.equalTo(16)
        }
        
        fourLabel.snp.makeConstraints { make in
            make.top.equalTo(threeLabel.snp.bottom).offset(5)
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-70)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.right.equalToSuperview().offset(-21)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
