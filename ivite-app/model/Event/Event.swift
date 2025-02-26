//
//  Event.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 27/01/2025.
//

import Foundation
import Firebase

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

extension Event  {
    enum CodingKeys: String, CodingKey {
        case id, title, date, timeZone, hostName, coHosts, location, city, state, zipCode, note
        case isBringListActive, bringList, guests, canvas, gifts, status, canvasImageURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        timeZone = try? container.decode(String.self, forKey: .timeZone)
        hostName = try? container.decode(String.self, forKey: .hostName)
        coHosts = (try? container.decode([CoHost].self, forKey: .coHosts)) ?? []
        location = try? container.decode(String.self, forKey: .location)
        city = try? container.decode(String.self, forKey: .city)
        state = try? container.decode(String.self, forKey: .state)
        zipCode = try? container.decode(String.self, forKey: .zipCode)
        note = try? container.decode(String.self, forKey: .note)
        isBringListActive = (try? container.decode(Bool.self, forKey: .isBringListActive)) ?? false
        bringList = (try? container.decode([BringListItem].self, forKey: .bringList)) ?? []
        guests = (try? container.decode([Guest].self, forKey: .guests)) ?? []
        canvas = try? container.decode(Canvas.self, forKey: .canvas)
        gifts = (try? container.decode([Gift].self, forKey: .gifts)) ?? []
        status = (try? container.decode(EventStatus.self, forKey: .status)) ?? .draft
        canvasImageURL = try? container.decode(String.self, forKey: .canvasImageURL)
        
        // 🔥 Handle Firestore Timestamp conversion
        if let timestamp = try? container.decode(Timestamp.self, forKey: .date) {
            date = timestamp.dateValue()
        } else {
            date = nil
        }
    }
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

extension CreatorFlowModel {
    init(from event: Event) {
        self.originalCanvas = event.canvas
        self.canvas = event.canvas
        
        self.image = nil

        self.eventDetailsViewModel = EventDetailsViewModel(
            eventTitle: event.title,
            date: event.date,
            timeZone: event.timeZone,
            hostName: event.hostName,
            coHosts: event.coHosts,
            location: event.location,
            city: event.city,
            state: event.state,
            zipCode: event.zipCode,
            note: event.note,
            isBringListActive: event.isBringListActive,
            bringList: event.bringList
        )
    
        self.giftDetailsViewModel = GiftDetailsViewModel()
        giftDetailsViewModel.gifts = event.gifts
        
        self.guests = event.guests
        self.canvasImageURL = event.canvasImageURL
    }
}
