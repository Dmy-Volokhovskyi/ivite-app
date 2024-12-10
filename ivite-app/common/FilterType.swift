//
//  FilterType.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 20/11/2024.
//

import UIKit

enum FilterType {
    case alphabet
    case defaultFilter
}

extension FilterType {
    var image: UIImage {
        switch self {
        case .alphabet:
            return .alfabet.withTintColor(.dark30, renderingMode: .alwaysTemplate)
        case .defaultFilter:
            return .filter.withTintColor(.dark30, renderingMode: .alwaysTemplate)
        }
    }
}
