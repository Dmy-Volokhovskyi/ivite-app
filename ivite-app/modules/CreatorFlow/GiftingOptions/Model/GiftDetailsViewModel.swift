//
//  GiftDetailsViewModel.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 04/11/2024.
//

import Foundation

final class GiftDetailsViewModel {
    var gifts: [Gift] = []
}

final class Gift {
    init(name: String, link: String?, image: Data?) {
        self.name = name
        self.link = link
        self.image = image
    }
    
    let id: UUID = .init()
    var name: String
    var link: String?
    var image: Data?
}
