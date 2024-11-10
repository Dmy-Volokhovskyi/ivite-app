//
//  AddGuestMenuView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 08/11/2024.
//

import UIKit

enum AddGuestMenu: CaseIterable {
    case usePastList
    case adressBook
    case addNewGuest
    
    var image: UIImage {
        switch self {
        case .usePastList: return .listChecklist
        case .adressBook: return .adressBook
        case .addNewGuest: return .userAdd
        }
    }
    
    var title: String {
        switch self {
        case .usePastList: return "Use Past Guest list"
        case .adressBook: return "Address Book"
        case .addNewGuest: return "Add new guest"
        }
    }
}

final class AddGuestMenuView: BaseView {
    private let menuStackView = UIStackView()
    
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
            menuStackView.addArrangedSubview(AddGuestsmenuItem(menuItem: menuItem))
        })
    }
}
