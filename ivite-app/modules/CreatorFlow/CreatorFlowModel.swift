//
//  CreatorFlowModel.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import UIKit

struct CreatorFlowModel {
    var originalCanvas: Canvas?
    var canvas: Canvas?
    var image: UIImage?
    var eventDetailsViewModel = EventDetailsViewModel()
    var giftDetailsViewModel = GiftDetailsViewModel()
    var guests = [Guest]()
    var canvasImageURL: String?
}
