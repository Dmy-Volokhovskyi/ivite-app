//
//  BaseViewController.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import UIKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()

        setupView()
        addSubviews()
        constrainSubviews()
    }
    
    func setupView() { }
    func addSubviews() { }
    func constrainSubviews() { }
}
