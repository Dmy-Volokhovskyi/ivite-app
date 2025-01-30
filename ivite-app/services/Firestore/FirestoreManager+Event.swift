//
//  FirestoreManager+Event.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 27/01/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension FirestoreManager {
    
    // MARK: - Create or Update Event
    func saveEvent(_ event: Event) async throws {
        let eventRef = db.collection(FirestoreCollection.events.rawValue).document(event.id)
        
        // Convert the event to a dictionary
        var eventData = try event.toDictionary()
        eventData["createdAt"] = FieldValue.serverTimestamp()
        eventData["updatedAt"] = FieldValue.serverTimestamp()
        
        try await eventRef.setData(eventData, merge: true)
    }
    
    // MARK: - Fetch Single Event
    func fetchEvent(eventId: String) async throws -> Event {
        let eventRef = db.collection(FirestoreCollection.events.rawValue).document(eventId)
        let snapshot = try await eventRef.getDocument()
        
        guard let data = snapshot.data() else {
            throw NSError(domain: "com.app.firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found"])
        }
        
        // Map Firestore data to Event model
        return try Event.fromDictionary(data)
    }
    
    // MARK: - Fetch All Events
    func fetchAllEvents() async throws -> [Event] {
        let snapshot = try await db.collection(FirestoreCollection.events.rawValue).getDocuments()
        
        return try snapshot.documents.compactMap { document in
            let data = document.data()
            return try? Event.fromDictionary(data)
        }
    }
    
    // MARK: - Delete Event
    func deleteEvent(eventId: String) async throws {
        let eventRef = db.collection(FirestoreCollection.events.rawValue).document(eventId)
        try await eventRef.delete()
    }
}
