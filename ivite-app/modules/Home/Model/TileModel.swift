//
//  TileModel.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import UIKit

struct TileModel {
    let imageName: String
    let title: String
    
    var image: UIImage? {
        return UIImage(named: imageName)
    }
}
