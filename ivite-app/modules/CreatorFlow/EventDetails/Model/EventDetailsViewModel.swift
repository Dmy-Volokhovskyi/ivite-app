//
//  EventDetailsViewModel.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import Foundation

protocol EventDetailsViewModelDelegate: AnyObject {
    func isReadyToSaveChanged(to value: Bool)
}

class EventDetailsViewModel {
    var eventTitle: String? {
        didSet { notifyIsReadyToSaveChanged() }
    }
    var date: Date? {
        didSet { notifyIsReadyToSaveChanged() }
    }
    var timeZone: String? {
        didSet { notifyIsReadyToSaveChanged() }
    }
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
    
    weak var delegate: EventDetailsViewModelDelegate?
    
    var isReadyToSave: Bool {
        !(eventTitle?.isEmpty ?? true) && date != nil && !(timeZone?.isEmpty ?? true)
    }
    
    private func notifyIsReadyToSaveChanged() {
        print(isReadyToSave, "IS READY")
        delegate?.isReadyToSaveChanged(to: isReadyToSave)
    }
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
    
    func reviewFormattedDate() -> String {
        guard let date = self.date else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func reviewFormattedTimezone() -> String {
        guard let date = self.date else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "(a z)"
        return dateFormatter.string(from: date)
    }
}

struct CoHost: Codable {
    let id: String
    var name: String
    var email: String
    
    init(id: String = UUID().uuidString, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

struct BringListItem: Codable {
    let id: String
    var name: String?
    var count: Int?
    
    init(id: String = UUID().uuidString, name: String? = nil, count: Int? = nil) {
        self.id = id
        self.name = name
        self.count = count
    }
}

