//
//  FaceView.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FaceView: UIView {
    
    let disposeBag = DisposeBag()
    
    var nextBlock: (() -> Void)?
    
    lazy var oneView: FaceListView = {
        let oneView = FaceListView()
        let type = LanguageManager.getLanguageCode()
        let imageStr = type == "2" ? "id_f_image" : "en_f_image"
        oneView.oneImageView.image = UIImage(named: imageStr)
        oneView.twoImageView.image = UIImage(named: "id_au_image")
        oneView.nameLabel.text = LanguageManager.localizedString(for: "Please upload a photo of the front side of your ID card, ensuring that the borders are intact and all key information is fully visible.")
        return oneView
    }()
    
    lazy var twoView: FaceListView = {
        let twoView = FaceListView()
        let type = LanguageManager.getLanguageCode()
        let imageStr = type == "2" ? "id_fa_image" : "en_fa_image"
        twoView.oneImageView.image = UIImage(named: imageStr)
        twoView.twoImageView.image = UIImage(named: "id_auimage_image")
        twoView.nameLabel.text = LanguageManager.localizedString(for: "Please position your face fully within the on-screen face frame in a well-lit, unobstructed environment.")
        return twoView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle(LanguageManager.localizedString(for: "Next"), for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "home_apply_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nextBtn)
        addSubview(scrollView)
        scrollView.addSubview(oneView)
        scrollView.addSubview(twoView)
        
        
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 313, height: 50))
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        
        oneView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 335, height: 199))
        }
        
        twoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneView.snp.bottom).offset(53)
            make.size.equalTo(CGSize(width: 335, height: 199))
            make.bottom.equalToSuperview().offset(-20)
        }
        
        nextBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.nextBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
