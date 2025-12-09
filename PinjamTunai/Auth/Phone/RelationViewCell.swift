//
//  RelationViewCell.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/9.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RelationViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var relationBlock: (() -> Void)?
    var phoneBlock: (() -> Void)?
    
    var model: princeModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.shrank ?? ""
            
            oneLabel.text = model.account ?? ""
            twoLabel.text = model.music ?? ""
            
            threeLabel.text = model.giving ?? ""
            fourLabel.text = model.backing ?? ""
            
            let name = model.bore ?? ""
            let phone = model.beloved ?? ""
            
            
            let fairy = model.fairy ?? ""
            if fairy.isEmpty {
                threeLabel.textColor = UIColor(hex: "#939393")
            }else {
                threeLabel.textColor = UIColor(hex: "#3B3B3B")
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(hex: "#525252")
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
        return titleLabel
    }()
    
    lazy var yellowView: UIView = {
        let yellowView = UIView()
        yellowView.backgroundColor = UIColor.init(hex: "#FFCC6C")
        yellowView.layer.cornerRadius = 10
        yellowView.layer.masksToBounds = true
        return yellowView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "phone_li_image")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "phone_li_image")
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "yel_ic_image")
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        fourImageView.image = UIImage(named: "phone_icon_image")
        return fourImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hex: "#FFFFFF")
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(400))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = UIColor.init(hex: "#FFFFFF")
        twoLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(400))
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textAlignment = .left
        threeLabel.textColor = UIColor.init(hex: "#939393")
        threeLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textAlignment = .left
        fourLabel.textColor = UIColor.init(hex: "#939393")
        fourLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        return fourLabel
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(yellowView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(oneImageView)
        contentView.addSubview(twoImageView)
        oneImageView.addSubview(threeImageView)
        twoImageView.addSubview(fourImageView)
        
        oneImageView.addSubview(oneLabel)
        twoImageView.addSubview(twoLabel)
        
        oneImageView.addSubview(threeLabel)
        twoImageView.addSubview(fourLabel)
        
        contentView.addSubview(oneBtn)
        contentView.addSubview(twoBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        yellowView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 8, height: 8))
            make.left.equalTo(titleLabel).offset(-4)
        }
        
        oneImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335, height: 57))
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        twoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335, height: 57))
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        threeImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.bottom.equalToSuperview().offset(-4)
        }
        
        fourImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.bottom.equalToSuperview().offset(-4)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(7)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(7)
        }
        
        threeLabel.snp.makeConstraints { make in
            make.right.equalTo(threeImageView.snp.left).offset(-10)
            make.left.equalTo(oneLabel).offset(2)
            make.height.equalTo(12)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        fourLabel.snp.makeConstraints { make in
            make.right.equalTo(fourImageView.snp.left).offset(-10)
            make.left.equalTo(twoLabel).offset(2)
            make.height.equalTo(12)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        oneBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335, height: 57))
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        twoBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335, height: 57))
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        oneBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.relationBlock?()
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.phoneBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
