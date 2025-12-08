//
//  File.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class LoginView: UIView {
    
    var codeBlock: (() -> Void)?
    
    var voiceBlock: (() -> Void)?
    
    var loginBlock: (() -> Void)?
    
    let disposeBag = DisposeBag()
        
    private lazy var oneLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageManager.localizedString(for: "Hello,")
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#6D95FC")
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private lazy var twoLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageManager.localizedString(for: "Welcome to Pinjam Tunai!")
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#666666")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "login_logo_image")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.layer.cornerRadius = 16
        whiteView.layer.masksToBounds = true
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.setTitle(LanguageManager.localizedString(for: "Log In"), for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        loginBtn.setBackgroundImage(UIImage(named: "home_apply_image"), for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        return loginBtn
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "login_nor_image"), for: .normal)
        oneBtn.setImage(UIImage(named: "login_sel_image"), for: .selected)
        oneBtn.isSelected = true
        return oneBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(400))
        nameLabel.textColor = UIColor.init(hex: "#D9D9D9")
        let fullText = LanguageManager.localizedString(for: "I have agreed to all the terms of the <Privacy Policy>.")
        let policyText = LanguageManager.localizedString(for: "<Privacy Policy>")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: attributedString.length))
        if let range = fullText.range(of: policyText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
        }
        nameLabel.attributedText = attributedString
        return nameLabel
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.text = LanguageManager.localizedString(for: "Phone number")
        phoneLabel.textAlignment = .left
        phoneLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(400))
        phoneLabel.textColor = UIColor(hex: "#373737")
        return phoneLabel
    }()
    
    lazy var phoneView: UIView = {
        let phoneView = UIView()
        phoneView.layer.cornerRadius = 8
        phoneView.layer.masksToBounds = true
        phoneView.layer.borderWidth = 1
        phoneView.layer.borderColor = UIColor.init(hex: "#000000").cgColor
        return phoneView
    }()
    
    lazy var codeLabel: UILabel = {
        let codeLabel = UILabel()
        codeLabel.text = LanguageManager.localizedString(for: "Verification code")
        codeLabel.textAlignment = .left
        codeLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(400))
        codeLabel.textColor = UIColor(hex: "#373737")
        return codeLabel
    }()
    
    lazy var codeView: UIView = {
        let codeView = UIView()
        codeView.layer.cornerRadius = 8
        codeView.layer.masksToBounds = true
        codeView.layer.borderWidth = 1
        codeView.layer.borderColor = UIColor.init(hex: "#000000").cgColor
        return codeView
    }()
    
    lazy var voiceLabel: UILabel = {
        let voiceLabel = UILabel()
        voiceLabel.text = LanguageManager.localizedString(for: "Get the voice verification code")
        voiceLabel.textAlignment = .right
        voiceLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        voiceLabel.textColor = UIColor(hex: "#C0C0C0")
        return voiceLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hex: "#C0C0C0")
        return lineView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = LanguageManager.localizedString(for: "+91")
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        descLabel.textColor = UIColor(hex: "#000000")
        return descLabel
    }()
    
    lazy var lView: UIView = {
        let lView = UIView()
        lView.backgroundColor = UIColor.init(hex: "#BDBDBD")
        return lView
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        phoneTextFiled.keyboardType = .numberPad
        phoneTextFiled.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: "Please Enter Your Phone Number"), attributes: [
            .foregroundColor: UIColor.init(hex: "#BDBDBD") as Any,
            .font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        ])
        phoneTextFiled.attributedPlaceholder = attrString
        phoneTextFiled.textColor = UIColor.init(hex: "#000000")
        return phoneTextFiled
    }()
    
    lazy var codeTextFiled: UITextField = {
        let codeTextFiled = UITextField()
        codeTextFiled.keyboardType = .numberPad
        codeTextFiled.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: "Please Enter Verification Code"), attributes: [
            .foregroundColor: UIColor.init(hex: "#BDBDBD") as Any,
            .font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        ])
        codeTextFiled.attributedPlaceholder = attrString
        codeTextFiled.textColor = UIColor.init(hex: "#000000")
        return codeTextFiled
    }()
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.layer.cornerRadius = 8
        codeBtn.layer.masksToBounds = true
        codeBtn.backgroundColor = UIColor.init(hex: "#6D95FC")
        codeBtn.setTitle(LanguageManager.localizedString(for: "Get Code"), for: .normal)
        codeBtn.setTitleColor(UIColor.white, for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        return codeBtn
    }()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#F2F4FA")
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(oneLabel)
        contentView.addSubview(twoLabel)
        contentView.addSubview(logoImageView)
        contentView.addSubview(whiteView)
        contentView.addSubview(loginBtn)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(oneBtn)
        stackView.addArrangedSubview(nameLabel)
        
        whiteView.addSubview(phoneLabel)
        whiteView.addSubview(phoneView)
        
        whiteView.addSubview(codeLabel)
        whiteView.addSubview(codeView)
        
        whiteView.addSubview(voiceLabel)
        whiteView.addSubview(lineView)
        
        phoneView.addSubview(descLabel)
        phoneView.addSubview(lView)
        phoneView.addSubview(phoneTextFiled)
        
        codeView.addSubview(codeTextFiled)
        codeView.addSubview(codeBtn)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(stackView.snp.bottom).offset(20)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(55)
            make.left.equalTo(contentView).offset(20)
            make.height.equalTo(48)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(7)
            make.left.equalTo(contentView).offset(20)
            make.height.equalTo(16)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.top).offset(-3)
            make.size.equalTo(CGSize(width: 78, height: 78))
            make.right.equalTo(contentView).inset(20)
        }
        
        whiteView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(38)
            make.size.equalTo(CGSize(width: 337, height: 217))
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 313, height: 50))
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).offset(200)
            make.height.equalTo(46)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(72)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        
        phoneView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(phoneLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(46)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(phoneView.snp.bottom).offset(11)
        }
        
        codeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(46)
        }
        
        voiceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-11)
            make.top.equalTo(codeView.snp.bottom).offset(8)
            make.height.equalTo(12)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(voiceLabel)
            make.bottom.equalTo(voiceLabel).offset(1)
            make.height.equalTo(1)
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 47, height: 30))
        }
        
        lView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(descLabel.snp.right)
            make.size.equalTo(CGSize(width: 1, height: 24))
        }
        
        phoneTextFiled.snp.makeConstraints { make in
            make.left.equalTo(lView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        
        codeTextFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-110)
            make.height.equalTo(40)
        }
        
        codeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-4)
            make.size.equalTo(CGSizeMake(90, 38))
            make.centerY.equalToSuperview()
        }
        
        loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.loginBlock?()
        }).disposed(by: disposeBag)
        
        codeBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.codeBlock?()
        }).disposed(by: disposeBag)
        
        voiceLabel.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.voiceBlock?()
        }).disposed(by: disposeBag)
        
        oneBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            oneBtn.isSelected.toggle()
        }).disposed(by: disposeBag)
        
        nameLabel.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            oneBtn.isSelected.toggle()
        }).disposed(by: disposeBag)
    }
}
