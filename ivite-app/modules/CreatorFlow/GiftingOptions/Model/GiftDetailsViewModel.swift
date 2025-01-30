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

final class Gift: Codable {
    let id: UUID
    var name: String
    var link: String?
    var image: Data?
    var imageURL: URL?
    var gifterEmail: String?
    
    init(id: UUID = UUID(), // Generate a new UUID by default
         name: String,
         link: String? = nil,
         image: Data? = nil,
         imageURL: URL? = nil,
         gifterEmail: String? = nil) {
        self.id = id
        self.name = name
        self.link = link
        self.image = image
        self.imageURL = imageURL
        self.gifterEmail = gifterEmail
    }
    
    // Custom coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case link
        case image
        case imageURL = "image_url"
        case gifterEmail = "gifter_email"
    }
    
    // Decode from a decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        image = try container.decodeIfPresent(Data.self, forKey: .image)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        gifterEmail = try container.decodeIfPresent(String.self, forKey: .gifterEmail)
    }
    
    // Encode to an encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encodeIfPresent(gifterEmail, forKey: .gifterEmail)
    }
}

