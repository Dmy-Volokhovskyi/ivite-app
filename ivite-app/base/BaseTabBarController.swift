//
//  BaseTabBarController.swift
//  ivite-app
//
//  Created by GoApps Developer on 02/09/2024.
//

import UIKit

class BaseTabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        super.loadView()

        setupTabBar()
    }

    func setupTabBar() {
        
    }

    func addViewControllers(controllers: [UIViewController]) {
        setViewControllers(controllers, animated: false)
    }
}
