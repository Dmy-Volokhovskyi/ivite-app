//
//  EventStatus.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 27/01/2025.
//


enum EventStatus: String, Codable {
    case draft      // Still being edited
    case pending    // Published but awaiting confirmation
    case done       // Event has concluded
}