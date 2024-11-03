//
//  ProfileMenu.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 28/10/2024.
//

import UIKit

enum ProfileMenuItem: CaseIterable {
    case dataPrivacy
    case orderHistory
    case recentPaymentMethod
    case logOut

    // Provide the icon and title for each menu item
    var title: String {
        switch self {
        case .dataPrivacy:
            return "Data privacy"
        case .orderHistory:
            return "Order history"
        case .recentPaymentMethod:
            return "Recent Payment Method"
        case .logOut:
            return "Log out"
        }
    }

    var icon: UIImage? {
        switch self {
        case .dataPrivacy:
            return UIImage(resource: .shieldWarning)
        case .orderHistory:
            return UIImage(resource: .fileDocument)
        case .recentPaymentMethod:
            return UIImage(resource: .creditCard01)
        case .logOut:
            return UIImage(resource: .logOut)
        }
    }
    
    var hasChevron: Bool {
        switch self {
        case .dataPrivacy, .orderHistory, .recentPaymentMethod:
            return true
        case .logOut:
            return false
        }
    }
}
