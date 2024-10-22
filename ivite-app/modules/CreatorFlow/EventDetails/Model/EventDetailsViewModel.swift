//
//  EventDetailsViewModel.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import Foundation

struct EventDetailsViewModel {
    var date: Date?
    // Host
    var hostName: String?
    var coHosts: [CoHost] = []
    // Location
    var city: String?
    var location: String?
    var state: String?
    var zipCode: String?
    var note: String?
    // Bring List
    var isBringListActive: Bool = false
    var bringList: [BringListItem] = [BringListItem()]
}

extension EventDetailsViewModel {
    
    // Returns the formatted time string (00:00)
    func formattedTime() -> String {
        guard let date = self.date else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 24-hour format
        return dateFormatter.string(from: date)
    }
    
    // Returns the formatted date string (dd/MM/yyyy)
    func formattedDate() -> String {
        guard let date = self.date else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}

struct CoHost {
    let id = UUID().uuidString
    var name: String
    var email: String
}

struct BringListItem {
    let id = UUID().uuidString
    var name: String?
    var count: Int?
}
