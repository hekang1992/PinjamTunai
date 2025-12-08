//
//  OneView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class OneView: UIView {
    
    let disposeBag = DisposeBag()
    
    var applyBlock: ((String) -> Void)?
    
    var model: aboveModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.wind ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.bring ?? ""
            let applyStr = model.rushing ?? ""
            applyBtn.setTitle(applyStr, for: .normal)
            oneLabel.text = model.wondrous ?? ""
            twoLabel.text = model.throng ?? ""
            
            let desc = model.among ?? ""
            let time = model.fixed ?? ""
            
            let desc1 = model.wreath ?? ""
            let time1 = model.samite ?? ""
            
            threeLabel.text = "\(desc): \(time)"
            fourLabel.text = "\(desc1): \(time1)"
        }
    }
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "home_one_image")
        oneImageView.isUserInteractionEnabled = true
        oneImageView.contentMode = .scaleAspectFit
        return oneImageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "icon_head_image")
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 16
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
    
    lazy var serviceImageView: UIImageView = {
        let serviceImageView = UIImageView()
        serviceImageView.image = UIImage(named: "ser_head_image")
        serviceImageView.contentMode = .scaleAspectFit
        return serviceImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        if LoginConfig.hasValidToken() {
            phoneLabel.text = maskPhoneNumber(LoginConfig.getPhone())
        } else {
            phoneLabel.text = LanguageManager.localizedString(for: "Not logged In")
        }
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = UIColor(hex: "#3D3D3D")
        phoneLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return phoneLabel
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 16
        whiteView.layer.masksToBounds = true
        whiteView.layer.shadowColor = UIColor.black.cgColor
        whiteView.layer.shadowOffset = CGSize(width: 0, height: 2)
        whiteView.layer.shadowOpacity = 0.1
        whiteView.layer.shadowRadius = 4
        return whiteView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.clipsToBounds = true
        logoImageView.backgroundColor = UIColor.gray
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor(hex: "#3D3D3D")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return nameLabel
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var cardImageView: UIImageView = {
        let cardImageView = UIImageView()
        cardImageView.image = UIImage(named: "home_card_image")
        return cardImageView
    }()
    
    lazy var loanBtn: UIButton = {
        let loanBtn = UIButton(type: .custom)
        loanBtn.adjustsImageWhenHighlighted = true
        let type = LanguageManager.getLanguageCode()
        if type == "2" {
            loanBtn.setImage(UIImage(named: "id_ag_imge_image"), for: .normal)
        }else {
            loanBtn.setImage(UIImage(named: "home_loan_image"), for: .normal)
        }
        return loanBtn
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        applyBtn.setBackgroundImage(UIImage(named: "home_apply_image"), for: .normal)
        applyBtn.adjustsImageWhenHighlighted = true
        return applyBtn
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        let type = LanguageManager.getLanguageCode()
        if type == "2" {
            twoImageView.image = UIImage(named: "id_imge_image")
        }else {
            twoImageView.image = UIImage(named: "home_two_image")
        }
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        let type = LanguageManager.getLanguageCode()
        if type == "2" {
            threeImageView.image = UIImage(named: "id_ad_imge_image")
        }else {
            threeImageView.image = UIImage(named: "home_three_image")
        }
        return threeImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor(hex: "#FFFFFF")
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .center
        twoLabel.textColor = UIColor(hex: "#FFFFFF")
        twoLabel.font = UIFont.systemFont(ofSize: 52, weight: .regular)
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textAlignment = .center
        threeLabel.textColor = UIColor(hex: "#C4D4FF")
        threeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textAlignment = .center
        fourLabel.textColor = UIColor(hex: "#C4D4FF")
        fourLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return fourLabel
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = UIColor(hex: "#F5F5F5")
        
        // Add subviews
        addSubview(oneImageView)
        oneImageView.addSubview(iconImageView)
        oneImageView.addSubview(serviceImageView)
        oneImageView.addSubview(phoneLabel)
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(whiteView)
        
        // Setup stackView
        whiteView.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(nameLabel)
        
        whiteView.addSubview(cardImageView)
        whiteView.addSubview(loanBtn)
        whiteView.addSubview(applyBtn)
        
        scrollView.addSubview(twoImageView)
        scrollView.addSubview(threeImageView)
        
        cardImageView.addSubview(oneLabel)
        cardImageView.addSubview(twoLabel)
        cardImageView.addSubview(threeLabel)
        cardImageView.addSubview(fourLabel)
        
        whiteView.addSubview(clickBtn)
    }
    
    private func setupConstraints() {
        // oneImageView constraints
        oneImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(68)
        }
        
        // iconImageView constraints
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.left.equalToSuperview().offset(15)
        }
        
        // serviceImageView constraints
        serviceImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.right.equalToSuperview().offset(-12)
        }
        
        // phoneLabel constraints
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.right.lessThanOrEqualTo(serviceImageView.snp.left).offset(-8)
            make.height.equalTo(32)
        }
        
        // scrollView constraints
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(5)
        }
        
        // contentView constraints
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView)
        }
        
        // whiteView constraints
        whiteView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(319)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        // stackView constraints - 居中显示
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 315, height: 167))
        }
        
        // logoImageView constraints
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        loanBtn.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 190, height: 15))
        }
        
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(loanBtn.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 315, height: 55))
        }
        
        twoImageView.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 113))
        }
        
        threeImageView.snp.makeConstraints { make in
            make.top.equalTo(twoImageView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 199))
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(15)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(2)
            make.height.equalTo(63)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        threeLabel.snp.makeConstraints { make in
            make.top.equalTo(twoLabel.snp.bottom).offset(12)
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        fourLabel.snp.makeConstraints { make in
            make.top.equalTo(threeLabel.snp.bottom).offset(7)
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clickBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            let productID = String(self.model?.windows ?? 0)
            self.applyBlock?(productID)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    func updatePhoneNumber() {
        if LoginConfig.hasValidToken() {
            phoneLabel.text = LoginConfig.getPhone()
        } else {
            phoneLabel.text = "Not logged In"
        }
    }
    
    func updateName(_ name: String) {
        nameLabel.text = name
    }
    
    func updateLogoImage(_ image: UIImage?) {
        logoImageView.image = image
    }
    
    func maskPhoneNumber(_ phone: String) -> String {
        guard phone.count >= 10 else { return phone }
        
        let startIndex = phone.index(phone.startIndex, offsetBy: 3)
        let endIndex = phone.index(phone.startIndex, offsetBy: 6)
        
        var result = phone
        result.replaceSubrange(startIndex...endIndex, with: "****")
        return result
    }
}

