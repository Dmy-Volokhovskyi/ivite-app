//
//  AddGuestMenu.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 20/11/2024.
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
