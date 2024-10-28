//
//  ProfileMenuView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 28/10/2024.
//


import UIKit

final class ProfileMenuView: BaseControll {
    private let menuStackView = UIStackView()

//    override init() {
//        super.init(frame: .zero)
//        
//        addMenuItems()
//    }
//
//    @MainActor required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func setupView() {
        super.setupView()

        menuStackView.axis = .vertical
        menuStackView.spacing = 16
//        menuStackView.alignment = .fill
//        menuStackView.distribution = .fill

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
            menuStackView.addArrangedSubview(menuItemView)
        }
    }
}
