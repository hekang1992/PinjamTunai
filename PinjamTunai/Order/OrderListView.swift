//
//  OrderListView.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
//

import UIKit
import SnapKit

class OrderListView: UIView {
    
    private var selectedIndex: Int = 0
    
    private var filterButtons: [UIButton] = []
    
    var clickBlock: ((String) -> Void)?
    
    var cellTapBlock: ((String) -> Void)?
    
    var modelArray: [flewModel]?
    
    // MARK: - UI Components
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(hex: "#0E0F0F")
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.text = LanguageManager.localizedString(for: "My Order")
        return nameLabel
    }()
    
    lazy var filterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 31
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor(hex: "#E4ECFF").cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 1
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var allButton: UIButton = {
        return createFilterButton(title: LanguageManager.localizedString(for: "All"), tag: 0)
    }()
    
    lazy var applyButton: UIButton = {
        return createFilterButton(title: LanguageManager.localizedString(for: "Apply"), tag: 1)
    }()
    
    lazy var repaymentButton: UIButton = {
        return createFilterButton(title: LanguageManager.localizedString(for: "Repayment"), tag: 2)
    }()
    
    lazy var finishButton: UIButton = {
        return createFilterButton(title: LanguageManager.localizedString(for: "Finish"), tag: 3)
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(OrderListViewCell.self, forCellReuseIdentifier: "OrderListViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    lazy var emptyView: OrderEmptyView = {
        let emptyView = OrderEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupFilterButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createFilterButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        button.setTitleColor(UIColor(hex: "#818181"), for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.tag = tag
        button.backgroundColor = .clear
        button.layer.cornerRadius = 21
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
                
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.lineBreakMode = .byClipping
        
        return button
    }
    
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(filterContainerView)
        filterContainerView.addSubview(stackView)
        
        stackView.addArrangedSubview(allButton)
        stackView.addArrangedSubview(applyButton)
        stackView.addArrangedSubview(repaymentButton)
        stackView.addArrangedSubview(finishButton)
        
        addSubview(contentView)
        contentView.addSubview(tableView)
        contentView.addSubview(emptyView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        filterContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.width.equalTo(335)
            make.height.equalTo(62)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        [allButton, applyButton, repaymentButton, finishButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(42)
            }
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(filterContainerView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
    }
    
    private func setupFilterButtons() {
        filterButtons = [allButton, applyButton, repaymentButton, finishButton]
        selectButton(at: 0)
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        selectButton(at: sender.tag)
    }
    
    private func selectButton(at index: Int) {
        filterButtons.forEach { button in
            button.backgroundColor = .clear
            button.isSelected = false
        }
        
        let selectedButton = filterButtons[index]
        selectedButton.backgroundColor = UIColor(hex: "#6D95FC")
        selectedButton.isSelected = true
        
        selectedIndex = index
        handleFilterSelection(at: index)
    }
    
    private func handleFilterSelection(at index: Int) {
        switch index {
        case 0:
            clickBlock?("4")
        case 1:
            clickBlock?("7")
        case 2:
            clickBlock?("6")
        case 3:
            clickBlock?("5")
        default:
            break
        }
    }
    
    func selectFilter(at index: Int) {
        guard index >= 0 && index < filterButtons.count else { return }
        selectButton(at: index)
    }
    
    func getSelectedIndex() -> Int {
        return selectedIndex
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustFontSizeIfNeeded()
    }
    
    private func adjustFontSizeIfNeeded() {
        filterButtons.forEach { button in
            if let title = button.title(for: .normal),
               let label = button.titleLabel,
               let font = label.font {
                
                let buttonWidth = button.bounds.width
                let padding: CGFloat = 24
                let availableWidth = buttonWidth - padding
                
                let textWidth = title.size(withAttributes: [.font: font]).width
                
                if textWidth > availableWidth {
                    let scaleFactor = availableWidth / textWidth
                    let newFontSize = min(14, font.pointSize * scaleFactor)
                    label.font = UIFont.systemFont(ofSize: newFontSize, weight: UIFont.Weight(500))
                }
            }
        }
    }
}

// MARK: - UITableView Delegate & DataSource
extension OrderListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListViewCell", for: indexPath) as! OrderListViewCell
        let model = modelArray?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = modelArray?[indexPath.row] {
            cellTapBlock?(model.readily ?? "")
        }
    }
}

