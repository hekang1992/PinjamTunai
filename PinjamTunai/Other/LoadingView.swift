//
//  LoadingView.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    
    // MARK: - Properties
    static let shared = LoadingView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = false
        return indicator
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Initialization
    private init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.clear
        
        addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
        
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func show() {
        DispatchQueue.main.async {
            guard let window = self.findKeyWindow() else { return }

            if self.superview == nil {
                window.addSubview(self)
                
                self.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                self.layoutIfNeeded()
            }
            
            self.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    func show(on view: UIView) {
        DispatchQueue.main.async {
            if self.superview == nil {
                view.addSubview(self)
                
                self.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                self.layoutIfNeeded()
            }
            
            self.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    private func findKeyWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
    
}

extension LoadingView {
    static func show() {
        shared.show()
    }
    
    static func hide() {
        shared.hide()
    }
    
    static func show(on view: UIView) {
        shared.show(on: view)
    }
}

