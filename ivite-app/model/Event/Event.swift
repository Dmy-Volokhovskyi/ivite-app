//
//  Event.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 27/01/2025.
//

import Foundation

struct Event: Codable {
    let id: String
    var title: String
    var date: Date?
    var timeZone: String?
    var hostName: String?
    var coHosts: [CoHost]
    var location: String?
    var city: String?
    var state: String?
    var zipCode: String?
    var note: String?
    var isBringListActive: Bool
    var bringList: [BringListItem]
    var guests: [Guest]
    var canvas: Canvas?
    var gifts: [Gift]
    var status: EventStatus
    var canvasImageURL: String?
    
    init(
        id: String = UUID().uuidString,
        title: String,
        date: Date? = nil,
        timeZone: String? = nil,
        hostName: String? = nil,
        coHosts: [CoHost] = [],
        location: String? = nil,
        city: String? = nil,
        state: String? = nil,
        zipCode: String? = nil,
        note: String? = nil,
        isBringListActive: Bool = false,
        bringList: [BringListItem] = [],
        guests: [Guest] = [],
        canvas: Canvas? = nil,
        gifts: [Gift] = [],
        status: EventStatus = .draft,
        canvasImageURL: String?
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.timeZone = timeZone
        self.hostName = hostName
        self.coHosts = coHosts
        self.location = location
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.note = note
        self.isBringListActive = isBringListActive
        self.bringList = bringList
        self.guests = guests
        self.canvas = canvas
        self.gifts = gifts
        self.status = status
    }
}
