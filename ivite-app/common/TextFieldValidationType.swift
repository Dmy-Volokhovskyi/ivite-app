//
//  TextFieldValidationType.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 15/10/2024.
//

import UIKit

enum TextFieldValidationType {
    case email
    case zipCode
    case none

    var regex: String {
        switch self {
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .zipCode:
            return "^\\d{5}(-\\d{4})?$" // US zip code format
        case .none:
            return ".*" // Allow everything
        }
    }
    
    func isValid(_ text: String?) -> Bool {
        guard let text = text else { return false }
        let regex = NSPredicate(format: "SELF MATCHES %@", self.regex)
        return regex.evaluate(with: text)
    }
}
