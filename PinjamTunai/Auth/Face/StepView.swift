//
//  StepView.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

import UIKit
import SnapKit

struct StepModel {
    let title: String
    let isCurrent: Bool
}

class StepIndicatorView: UIView {

    var modelArray: [StepModel]? {
        didSet { setupSteps() }
    }

    private let container = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .equalSpacing
        container.spacing = 12

        addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupSteps() {
        container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let steps = modelArray else { return }

        for (index, model) in steps.enumerated() {

            let circle = UILabel()
            circle.text = "\(index + 1)"
            circle.textAlignment = .center
            circle.textColor = model.isCurrent ? .white : .darkGray
            circle.backgroundColor = model.isCurrent ? UIColor.init(hex: "#FFCC6C") : UIColor(white: 0.85, alpha: 1)
            circle.layer.cornerRadius = 13
            circle.layer.masksToBounds = true

            circle.snp.makeConstraints { make in
                make.width.height.equalTo(26)
            }

            container.addArrangedSubview(circle)

            if index != steps.count - 1 {
                let line = UIView()
                line.backgroundColor = UIColor(white: 0.7, alpha: 1)

                line.snp.makeConstraints { make in
                    make.width.equalTo(14)
                    make.height.equalTo(2)
                }

                container.addArrangedSubview(line)
            }
        }
    }
}
