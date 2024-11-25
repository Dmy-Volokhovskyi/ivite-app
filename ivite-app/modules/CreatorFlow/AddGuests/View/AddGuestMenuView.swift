//
//  AddGuestMenuView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 08/11/2024.
//

import UIKit

protocol AddGuestMenuViewDelegate: AnyObject {
    func addGuestMenuView(_ menuView: AddGuestMenuView, didSelectMenuItem menuItem: AddGuestMenu)
}


final class AddGuestMenuView: BaseView {
    private let menuStackView = UIStackView()
    
    weak var delegate: AddGuestMenuViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        menuStackView.distribution = .fillEqually
        menuStackView.spacing = 12
        
        fillStackView()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(menuStackView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        menuStackView.autoPinEdgesToSuperviewEdges()
    }
    
    func fillStackView() {
        menuStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        AddGuestMenu.allCases.forEach({ menuItem in
            let menuItemView = AddGuestsMenuItem(menuItem: menuItem)
            menuItemView.addTarget(self, action: #selector(menuItemTapped(_:)), for: .touchUpInside)
            menuStackView.addArrangedSubview(menuItemView)
        })
    }
    
    @objc private func menuItemTapped(_ sender: UIControl) {
        guard let menuItemView = sender as? AddGuestsMenuItem else { return }
//        guard let menuItem = menuItemView.menuItem else { return }
        delegate?.addGuestMenuView(self, didSelectMenuItem: menuItemView.menuItem)
    }
}
