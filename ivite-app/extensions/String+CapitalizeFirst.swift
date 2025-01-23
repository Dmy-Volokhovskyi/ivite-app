//
//  String+CapitalizeFirst.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 21/01/2025.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).capitalized + dropFirst()
    }
    }
