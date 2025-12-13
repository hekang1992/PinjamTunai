//
//  PopOneView.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/9.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopOneView: UIView {
    
    var selectedIndex: Int? = nil
    
    var modelArray: [breezeModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    let disposeBag = DisposeBag()
    
    var cancelBlock: (() -> Void)?
    
    var confirmBlock: ((breezeModel) -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "com_po_gb_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "can_c_ia_image"), for: .normal)
        return cancelBtn
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.setTitle(LanguageManager.localizedString(for: "Confirm"), for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        loginBtn.setBackgroundImage(UIImage(named: "home_apply_image"), for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        return loginBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hex: "#FFCC6C")
        lineView.layer.cornerRadius = 2
        lineView.layer.masksToBounds = true
        return lineView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = LanguageManager.localizedString(for: "Confirm Information")
        nameLabel.textColor = UIColor.init(hex: "#000000")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(loginBtn)
        bgImageView.addSubview(lineView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(tableView)
        
        bgImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(406)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 313, height: 50))
            make.bottom.equalToSuperview().offset(-30)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(55)
            make.size.equalTo(CGSize(width: 64, height: 4))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(loginBtn.snp.top).offset(-20)
        }
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind(onNext: {  [weak self] in
            guard let self = self else { return }
            if selectedIndex == nil {
                Toaster.showMessage(with: LanguageManager.localizedString(for: "Please choose one"))
                return
            }
            if let model = modelArray?[selectedIndex ?? 0] {
                self.confirmBlock?(model)
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopOneView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = model?.bore ?? ""
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = UIColor.init(hex: "#6D95FC")
            cell.textLabel?.textColor = .white
        } else {
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = UIColor(hex: "#848484")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            selectedIndex = nil
        } else {
            selectedIndex = indexPath.row
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
