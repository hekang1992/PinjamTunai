//
//  TwoView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

import UIKit
import SnapKit

class TwoView: UIView {
    
    var model: aboveModel?
    
    var modelArray: [aboveModel]?
    
    var applyBlock: ((String) -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ProductAccViewCell.self,
                           forCellReuseIdentifier: "ProductAccViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(2)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
        
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(hex: "#6D95FC").cgColor,
            UIColor(hex: "#FFFFFF").cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        bgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bgView.bounds
    }
}

extension TwoView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAccViewCell", for: indexPath) as! ProductAccViewCell
        let model = modelArray?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 315
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .clear
        let twoHeadView = TwoHeadView()
        twoHeadView.model = model
        headView.addSubview(twoHeadView)
        twoHeadView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 279))
        }
        
        let iconImageView = UIImageView()
        let code = LanguageManager.getLanguageCode()
        iconImageView.image =  code == "2" ? UIImage(named: "id_moc_bg_image") : UIImage(named: "more_image_iac")
        headView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(23)
            make.top.equalTo(twoHeadView.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 100, height: 16))
        }
        twoHeadView.applyBlock = { [weak self] productID in
            guard let self = self else { return }
            self.applyBlock?(productID)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = modelArray?[indexPath.row] {
            self.applyBlock?(String(model.windows ?? 0))
        }
        
    }
    
}
