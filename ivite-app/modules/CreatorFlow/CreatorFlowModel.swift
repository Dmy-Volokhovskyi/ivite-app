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
}

extension Event {
    init(from creatorFlowModel: CreatorFlowModel, status: EventStatus = .draft) {
        // Map properties from `CreatorFlowModel` to `Event`
        self.id = UUID().uuidString
        self.title = creatorFlowModel.eventDetailsViewModel.eventTitle ?? "Untitled Event"
        self.date = creatorFlowModel.eventDetailsViewModel.date
        self.timeZone = creatorFlowModel.eventDetailsViewModel.timeZone
        self.hostName = creatorFlowModel.eventDetailsViewModel.hostName
        self.coHosts = creatorFlowModel.eventDetailsViewModel.coHosts
        self.location = creatorFlowModel.eventDetailsViewModel.location
        self.city = creatorFlowModel.eventDetailsViewModel.city
        self.state = creatorFlowModel.eventDetailsViewModel.state
        self.zipCode = creatorFlowModel.eventDetailsViewModel.zipCode
        self.note = creatorFlowModel.eventDetailsViewModel.note
        self.isBringListActive = creatorFlowModel.eventDetailsViewModel.isBringListActive
        self.bringList = creatorFlowModel.eventDetailsViewModel.bringList
        self.guests = creatorFlowModel.guests
        self.canvas = creatorFlowModel.canvas ?? creatorFlowModel.originalCanvas
        self.gifts = creatorFlowModel.giftDetailsViewModel.gifts
        self.status = status
    }
}
