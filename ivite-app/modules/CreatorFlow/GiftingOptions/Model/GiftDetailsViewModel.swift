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

import Foundation

struct Gift: Codable {
    let id: String  // Store as String for Firestore
    var name: String
    var link: String?
    var image: Data?
    var imageURL: String?
    var gifterId: String?  // Store user ID instead of email
    
    init(id: String = UUID().uuidString,
         name: String,
         link: String? = nil,
         image: Data? = nil,
         imageURL: String? = nil,
         gifterId: String?) {
        self.id = id
        self.name = name
        self.link = link
        self.image = image
        self.imageURL = imageURL
        self.gifterId = gifterId
    }
    
    // Convert to Firestore Dictionary
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "link": link ?? NSNull(),
            "image": image?.base64EncodedString() ?? NSNull(), // Store image as Base64 String
            "imageURL": imageURL ?? NSNull(),
            "gifterId": gifterId
        ]
    }
    
    // Convert from Firestore Dictionary
    static func fromDictionary(_ dictionary: [String: Any]) -> Gift? {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let gifterId = dictionary["gifterId"] as? String else {
            return nil
        }
        
        let link = dictionary["link"] as? String
        let imageURL = dictionary["imageURL"] as? String
        let imageData: Data? = (dictionary["image"] as? String).flatMap { Data(base64Encoded: $0) }
        
        return Gift(id: id, name: name, link: link, image: imageData, imageURL: imageURL, gifterId: gifterId)
    }
}


