//
//  BasicTableViewCell.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/9.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BasicTableViewCell: UITableViewCell {
    
    var textBlock: ((String) -> Void)?
    
    var model: groundModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.shrank ?? ""
            phoneTextFiled.placeholder = model.nestled ?? ""
            
            let blossoms = model.blossoms ?? 0
            
            if blossoms == 1 {
                phoneTextFiled.keyboardType = .numberPad
            }else {
                phoneTextFiled.keyboardType = .default
            }
            
            phoneTextFiled.text = model.winds ?? ""
            
            model.heads = phoneTextFiled.text
            
        }
    }
    
    let disposeBag = DisposeBag()
    
    var clickBlock: (() -> Void)?
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#2A2A2A")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
        return nameLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(hex: "#F5F6FA")
        bgView.layer.cornerRadius = 4
        bgView.layer.masksToBounds = true
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(hex: "#6B92F7").cgColor
        return bgView
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: ""), attributes: [
            .foregroundColor: UIColor.init(hex: "#C7C7C7") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        ])
        phoneTextFiled.attributedPlaceholder = attrString
        phoneTextFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        phoneTextFiled.textColor = UIColor.init(hex: "#FFCC6C")
        phoneTextFiled.leftView = UIView(frame: CGRectMake(0, 0, 15, 10))
        phoneTextFiled.leftViewMode = .always
        return phoneTextFiled
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(phoneTextFiled)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(16)
        }
        
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().offset(-18)
        }
        
        phoneTextFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(40)
        }
        
        phoneTextFiled.rx.text
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.textBlock?(text ?? "")
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
