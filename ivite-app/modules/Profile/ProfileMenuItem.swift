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
            return UIImage(systemName: "shield")
        case .orderHistory:
            return UIImage(systemName: "doc.text")
        case .recentPaymentMethod:
            return UIImage(systemName: "creditcard")
        case .logOut:
            return UIImage(systemName: "arrowshape.turn.up.left")
        }
    }
}
