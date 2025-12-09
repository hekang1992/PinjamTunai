//
//  BaseTabBarController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        self.delegate = self
    }
    
    private func setupTabBar() {
        let homeVC = createNavigationController(
            title: LanguageManager.localizedString(for: "Loan"),
            imageName: "home_nor_image",
            selectedImageName: "home_sel_image",
            viewController: HomeViewController()
        )
        
        let orderVC = createNavigationController(
            title: LanguageManager.localizedString(for: "Bills"),
            imageName: "bills_nor_image",
            selectedImageName: "bills_sel_image",
            viewController: OrderListViewController()
        )
        
        let centerVC = createNavigationController(
            title: LanguageManager.localizedString(for: "Mine"),
            imageName: "mine_nor_image",
            selectedImageName: "mine_sel_image",
            viewController: CenterViewController()
        )
        
        viewControllers = [homeVC, orderVC, centerVC]
        
        setupTabBarAppearance()
    }
    
    private func createNavigationController(title: String,
                                            imageName: String,
                                            selectedImageName: String,
                                            viewController: UIViewController) -> UINavigationController {
        
        let navController = BaseNavigationController(rootViewController: viewController)
        
        let normalImage = UIImage(named: imageName)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(UIColor(hex: "#333333"))
        
        let selectedImage = UIImage(named: selectedImageName)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(UIColor(hex: "#6D95FC"))
        
        navController.tabBarItem = UITabBarItem(
            title: title,
            image: normalImage,
            selectedImage: selectedImage
        )
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#333333"),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#6D95FC"),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        
        navController.tabBarItem.setTitleTextAttributes(normalTextAttributes, for: .normal)
        navController.tabBarItem.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        return navController
    }
    
    private func setupTabBarAppearance() {
        tabBar.borderWidth = 0
        tabBar.borderColor = .clear
        
        tabBar.backgroundColor = .clear
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .clear
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if !LoginConfig.hasValidToken() {
            let naeVc = BaseNavigationController(rootViewController: LoginViewController())
            naeVc.modalPresentationStyle = .overFullScreen
            self.present(naeVc, animated: true)
        }
    }
    
}

extension UIView {
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
