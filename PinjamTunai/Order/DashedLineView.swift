//
//  Untitled.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
//

import UIKit

class DashedLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDashedLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDashedLine()
    }
    
    private func setupDashedLine() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.init(hex: "#F2F2F2").cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [5, 5]
        
        let path = CGMutablePath()
        path.addLines(between: [
            CGPoint(x: 0, y: bounds.height/2),
            CGPoint(x: bounds.width, y: bounds.height/2)
        ])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        setupDashedLine()
    }
}
