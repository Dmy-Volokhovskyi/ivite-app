//
//  ContentSizeProvider.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 14/11/2024.
//

import Foundation

protocol ContentSizeProvider {
    func contentSize(for maxHeight: CGFloat) -> CGSize
}
