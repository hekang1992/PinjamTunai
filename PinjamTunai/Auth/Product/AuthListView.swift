//
//  AuthListView.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

import UIKit
import SnapKit

class AuthListView: UIView {
    
    var model: BaseModel? {
        didSet {
            guard let model = model else { return }
            oneLabel.text = model.kindness?.pavement?.rare ?? ""
            twoLabel.text = model.kindness?.pavement?.beauty ?? ""
        }
    }
    
    var cellBlock: ((midModel) -> Void)?

    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 16
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "list_head_bg_image")
        return bgImageView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "home_apply_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = UIColor(hex: "#FFFFFF")
        oneLabel.textAlignment = .center
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textColor = UIColor(hex: "#FFFFFF")
        twoLabel.textAlignment = .center
        twoLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight(500))
        return twoLabel
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
        tableView.register(AuthListViewCell.self, forCellReuseIdentifier: "AuthListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteView)
        whiteView.addSubview(bgImageView)
        bgImageView.addSubview(oneLabel)
        bgImageView.addSubview(twoLabel)
        addSubview(nextBtn)
        addSubview(tableView)
        whiteView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 130))
        }
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 313, height: 50))
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(15)
        }
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AuthListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.kindness?.mid?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthListViewCell", for: indexPath) as! AuthListViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.twoLabel.text = "0\(indexPath.row + 1)"
        let model = model?.kindness?.mid?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = model?.kindness?.mid?[indexPath.row] {
            self.cellBlock?(model)
        }
    }
}
