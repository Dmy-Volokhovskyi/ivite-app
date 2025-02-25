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
            let giftData = gift.toDictionary()
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
            return Gift.fromDictionary(giftData)
        }
        
        // ✅ Assign guests & gifts
        event.guests = guests
        event.gifts = gifts
        
        return event
    }

    // MARK: - Delete Event
    func deleteEvent(eventId: String) async throws {
        let eventRef = db.collection(FirestoreCollection.events.rawValue).document(eventId)
        try await eventRef.delete()
    }
    
    // MARK: - 1) Fetch main Event only
    func fetchAllEvents() async throws -> [Event] {
        let snapshot = try await db.collection(FirestoreCollection.events.rawValue).getDocuments()
        
        return snapshot.documents.compactMap { document in
            do {
                let originalData = document.data()
                var cleanData: [String: Any] = [:]
                let dateFormatter = ISO8601DateFormatter()
                
                for (key, value) in originalData {
                    if let timestamp = value as? Timestamp {
                        cleanData[key] = dateFormatter.string(from: timestamp.dateValue())
                    } else if let date = value as? Date {
                        cleanData[key] = dateFormatter.string(from: date)
                    } else {
                        cleanData[key] = value
                    }
                }
                
                // Encode after all conversions
                let jsonData = try JSONSerialization.data(withJSONObject: cleanData, options: [])
                return try JSONDecoder().decode(Event.self, from: jsonData)
            } catch {
                print("❌ Failed to decode Event: \(error)")
                return nil
            }
        }
    }
    
    // MARK: - 2) Fetch main Event + Guests
    func fetchAllEventsWithGuests() async throws -> [Event] {
        let snapshot = try await db.collection(FirestoreCollection.events.rawValue).getDocuments()
        var events: [Event] = []
        
        for document in snapshot.documents {
            do {
                // Decode main Event
                let originalData = document.data()
                var cleanData: [String: Any] = [:]
                let dateFormatter = ISO8601DateFormatter()
                
                for (key, value) in originalData {
                    if let timestamp = value as? Timestamp {
                        cleanData[key] = dateFormatter.string(from: timestamp.dateValue())
                    } else if let date = value as? Date {
                        cleanData[key] = dateFormatter.string(from: date)
                    } else {
                        cleanData[key] = value
                    }
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: cleanData, options: [])
                var event = try JSONDecoder().decode(Event.self, from: jsonData)
                
                // Now fetch Guests subcollection
                let guestsSnapshot = try await document.reference.collection("guests").getDocuments()
                let guests: [Guest] = guestsSnapshot.documents.compactMap { guestDoc in
                    do {
                        let guestData = guestDoc.data()
                        var guestCleanData: [String: Any] = [:]
                        
                        for (gKey, gValue) in guestData {
                            if let timestamp = gValue as? Timestamp {
                                guestCleanData[gKey] = dateFormatter.string(from: timestamp.dateValue())
                            } else if let date = gValue as? Date {
                                guestCleanData[gKey] = dateFormatter.string(from: date)
                            } else {
                                guestCleanData[gKey] = gValue
                            }
                        }
                        
                        let guestJson = try JSONSerialization.data(withJSONObject: guestCleanData, options: [])
                        return try JSONDecoder().decode(Guest.self, from: guestJson)
                    } catch {
                        print("❌ Failed to decode Guest: \(error)")
                        return nil
                    }
                }
                
                // Assign guests to the event
                event.guests = guests
                events.append(event)
            } catch {
                print("❌ Failed to decode Event: \(error)")
            }
        }
        
        return events
    }
    
    // MARK: - 3) Fetch main Event + Gifts
    func fetchAllEventsWithGifts() async throws -> [Event] {
        let snapshot = try await db.collection(FirestoreCollection.events.rawValue).getDocuments()
        var events: [Event] = []
        
        for document in snapshot.documents {
            do {
                // Decode main Event
                let originalData = document.data()
                var cleanData: [String: Any] = [:]
                let dateFormatter = ISO8601DateFormatter()
                
                for (key, value) in originalData {
                    if let timestamp = value as? Timestamp {
                        cleanData[key] = dateFormatter.string(from: timestamp.dateValue())
                    } else if let date = value as? Date {
                        cleanData[key] = dateFormatter.string(from: date)
                    } else {
                        cleanData[key] = value
                    }
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: cleanData, options: [])
                var event = try JSONDecoder().decode(Event.self, from: jsonData)
                
                // Now fetch Gifts subcollection
                let giftsSnapshot = try await document.reference.collection("gifts").getDocuments()
                let gifts: [Gift] = giftsSnapshot.documents.compactMap { giftDoc in
                    do {
                        let giftData = giftDoc.data()
                        var giftCleanData: [String: Any] = [:]
                        
                        for (gKey, gValue) in giftData {
                            if let timestamp = gValue as? Timestamp {
                                giftCleanData[gKey] = dateFormatter.string(from: timestamp.dateValue())
                            } else if let date = gValue as? Date {
                                giftCleanData[gKey] = dateFormatter.string(from: date)
                            } else {
                                giftCleanData[gKey] = gValue
                            }
                        }
                        
                        let giftJson = try JSONSerialization.data(withJSONObject: giftCleanData, options: [])
                        return try JSONDecoder().decode(Gift.self, from: giftJson)
                    } catch {
                        print("❌ Failed to decode Gift: \(error)")
                        return nil
                    }
                }
                
                // Assign gifts to the event
                event.gifts = gifts
                events.append(event)
            } catch {
                print("❌ Failed to decode Event: \(error)")
            }
        }
        
        return events
    }
    
    // MARK: - 4) Fetch main Event + Guests + Gifts
    func fetchAllEventsWithAll() async throws -> [Event] {
        let snapshot = try await db.collection(FirestoreCollection.events.rawValue).getDocuments()
        var events: [Event] = []
        
        for document in snapshot.documents {
            do {
                // Decode main Event
                let originalData = document.data()
                var cleanData: [String: Any] = [:]
                let dateFormatter = ISO8601DateFormatter()
                
                for (key, value) in originalData {
                    if let timestamp = value as? Timestamp {
                        cleanData[key] = dateFormatter.string(from: timestamp.dateValue())
                    } else if let date = value as? Date {
                        cleanData[key] = dateFormatter.string(from: date)
                    } else {
                        cleanData[key] = value
                    }
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: cleanData, options: [])
                var event = try JSONDecoder().decode(Event.self, from: jsonData)
                
                // ---- Fetch Guests
                let guestsSnapshot = try await document.reference.collection("guests").getDocuments()
                let guests: [Guest] = guestsSnapshot.documents.compactMap { guestDoc in
                    do {
                        let guestData = guestDoc.data()
                        var guestCleanData: [String: Any] = [:]
                        
                        for (gKey, gValue) in guestData {
                            if let timestamp = gValue as? Timestamp {
                                guestCleanData[gKey] = dateFormatter.string(from: timestamp.dateValue())
                            } else if let date = gValue as? Date {
                                guestCleanData[gKey] = dateFormatter.string(from: date)
                            } else {
                                guestCleanData[gKey] = gValue
                            }
                        }
                        
                        let guestJson = try JSONSerialization.data(withJSONObject: guestCleanData, options: [])
                        return try JSONDecoder().decode(Guest.self, from: guestJson)
                    } catch {
                        print("❌ Failed to decode Guest: \(error)")
                        return nil
                    }
                }
                event.guests = guests
                
                // ---- Fetch Gifts
                let giftsSnapshot = try await document.reference.collection("gifts").getDocuments()
                let gifts: [Gift] = giftsSnapshot.documents.compactMap { giftDoc in
                    do {
                        let giftData = giftDoc.data()
                        var giftCleanData: [String: Any] = [:]
                        
                        for (gKey, gValue) in giftData {
                            if let timestamp = gValue as? Timestamp {
                                giftCleanData[gKey] = dateFormatter.string(from: timestamp.dateValue())
                            } else if let date = gValue as? Date {
                                giftCleanData[gKey] = dateFormatter.string(from: date)
                            } else {
                                giftCleanData[gKey] = gValue
                            }
                        }
                        
                        let giftJson = try JSONSerialization.data(withJSONObject: giftCleanData, options: [])
                        return try JSONDecoder().decode(Gift.self, from: giftJson)
                    } catch {
                        print("❌ Failed to decode Gift: \(error)")
                        return nil
                    }
                }
                event.gifts = gifts
                
                events.append(event)
            } catch {
                print("❌ Failed to decode Event: \(error)")
            }
        }
        
        return events
    }

}
