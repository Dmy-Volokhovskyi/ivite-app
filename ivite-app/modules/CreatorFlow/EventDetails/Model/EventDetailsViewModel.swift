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
    
    var isLocationActive: Bool {
        !(city?.isEmpty ?? true) || !(location?.isEmpty ?? true) || isBringListActive || !(zipCode?.isEmpty ?? true)
        || !(state?.isEmpty ?? true)
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

extension EventDetailsViewModel {
    convenience init(eventTitle: String?,
                     date: Date?,
                     timeZone: String?,
                     hostName: String?,
                     coHosts: [CoHost],
                     location: String?,
                     city: String?,
                     state: String?,
                     zipCode: String?,
                     note: String?,
                     isBringListActive: Bool,
                     bringList: [BringListItem]) {
        self.init()
        self.eventTitle = eventTitle
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
    }
}
