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
        
        // Convert the event to a dictionary (without guests/gifts)
        var eventData = try event.toDictionary()
        eventData["createdAt"] = FieldValue.serverTimestamp()
        eventData["updatedAt"] = FieldValue.serverTimestamp()
        
        // Save event data (without guests & gifts)
        try await eventRef.setData(eventData, merge: true)
    }

    func saveGuests(for eventId: String, guests: [Guest]) async throws {
        let guestsCollectionRef = db.collection(FirestoreCollection.events.rawValue)
            .document(eventId)
            .collection("guests")
        
        for guest in guests {
            let guestRef = guestsCollectionRef.document(guest.id)
            let guestData = try guest.toDictionary()
            try await guestRef.setData(guestData, merge: true)
        }
    }

    func saveGifts(for eventId: String, gifts: [Gift]) async throws {
        let giftsCollectionRef = db.collection(FirestoreCollection.events.rawValue)
            .document(eventId)
            .collection("gifts")
        
        for var gift in gifts {
            // If the gift has an image, upload it to Storage
            if let imageData = gift.image {
                let storagePath = "events/\(eventId)/gifts/\(gift.id).jpg"
                let imageURL = try await uploadImageToStorage(image: UIImage(data: imageData) ?? UIImage(), path: storagePath)
                gift.imageURL = imageURL
                gift.image = nil // Remove raw image from Firestore storage
            }
            
            let giftRef = giftsCollectionRef.document(gift.id)
            let giftData = try gift.toDictionary()
            try await giftRef.setData(giftData, merge: true)
        }
    }

    
    // MARK: - Fetch Single Event
    func getEvent(withId eventId: String) async throws -> Event? {
        let eventRef = db.collection(FirestoreCollection.events.rawValue).document(eventId)
        
        // 🏃‍♂️ Fetch Event, Guests & Gifts in parallel
        async let eventSnapshot = try await eventRef.getDocument()
        async let guestsSnapshot = try await eventRef.collection("guests").getDocuments()
        async let giftsSnapshot = try await eventRef.collection("gifts").getDocuments()
        
        // 🛑 Unwrap Event Data
        guard let eventData = try await eventSnapshot.data(),
              var event = Event.fromDictionary(eventData) else {
            throw NSError(domain: "com.app.firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found"])
        }
        
        // 🏃‍♂️ Decode Guests (skip invalid ones)
        let guests: [Guest] = try await guestsSnapshot.documents.compactMap { doc in
            let guestData = doc.data()
            return try? Guest.fromDictionary(guestData)
        }
        
        // 🏃‍♂️ Decode Gifts (skip invalid ones)
        let gifts: [Gift] = try await giftsSnapshot.documents.compactMap { doc in
            let giftData = doc.data()
            return try? Gift.fromDictionary(giftData)
        }
        
        // ✅ Assign guests & gifts
        event.guests = guests
        event.gifts = gifts
        
        return event
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
