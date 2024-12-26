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
    let id: UUID = .init()
    var name: String
    var link: String?
    var image: Data?
    var imageURL: URL?
    var gifterEmail: String?
    
    init(name: String,
         link: String?,
         image: Data?,
         imageURL: URL? = nil,
         gifterEmail: String? = nil) {
        self.name = name
        self.link = link
        self.image = image
        self.imageURL = imageURL
        self.gifterEmail = gifterEmail
    }
}
