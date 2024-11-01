//
//  ProfileMenuView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 28/10/2024.
//


import UIKit

protocol ProfileMenuViewDelegate: AnyObject {
    func profileMenuView(_ profileMenuView: ProfileMenuView, didSelectMenuItem menuItem: ProfileMenuItem)
}

final class ProfileMenuView: BaseView {
    private let menuStackView = UIStackView()

    // Define a delegate to notify when a menu item is selected
    weak var delegate: ProfileMenuViewDelegate?

    override func setupView() {
        super.setupView()

        menuStackView.axis = .vertical
        menuStackView.spacing = 16
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addMenuItems()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(menuStackView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        menuStackView.autoPinEdgesToSuperviewEdges()
    }

    private func addMenuItems() {
        ProfileMenuItem.allCases.forEach { menuItem in
            let menuItemView = MenuItemView(menuItem: menuItem)
            menuItemView.didTapItem = { [weak self] item in
                guard let self = self else { return }
                self.delegate?.profileMenuView(self, didSelectMenuItem: item)
            }
            menuStackView.addArrangedSubview(menuItemView)
        }
    }
}

