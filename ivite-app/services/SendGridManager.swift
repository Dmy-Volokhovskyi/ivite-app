//
//  SendGridManager.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 03/02/2025.
//

import Foundation

struct SendGridConstants {
    static let apiKey = "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"
    static let sendGridURL = "https://api.sendgrid.com/v3/mail/send"
    static let templateID = "d-2dc51911e5b14344b841e42195a62219"
    static let senderEmail = "info@ivite.app"
}

class SendGridManager {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// Public function to send emails to multiple guests
    func sendEmails(to guests: [Guest], eventId: String, senderName: String) async {
        await withTaskGroup(of: Void.self) { group in
            for guest in guests {
                group.addTask {
                    do {
                        try await self.sendEmail(to: guest, eventId: eventId, senderName: senderName)
                        print("✅ Email sent to: \(guest.email)")
                    } catch {
                        print("❌ Failed to send email to \(guest.email): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    /// Private function to send an email to a single guest
    private func sendEmail(to guest: Guest, eventId: String, senderName: String) async throws {
        guard let url = URL(string: SendGridConstants.sendGridURL) else {
            throw NSError(domain: "SendGridError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        // ✅ Ensure guestId is passed in the event URL
        let viewDetailsURL = "https://postcard.ivite.app/version-test/event_firebase?eventId=\(eventId)&guestId=\(guest.id)&debug_mode=true"
        
        let emailData: [String: Any] = [
            "personalizations": [
                [
                    "to": [["email": guest.email]],
                    "dynamic_template_data": [
                        "Sender_Name": senderName,
                        "View_Details_URL": viewDetailsURL
                    ]
                ]
            ],
            "from": ["email": SendGridConstants.senderEmail],
            "subject": "Hello!",
            "template_id": SendGridConstants.templateID
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: emailData) else {
            throw NSError(domain: "SendGridError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON"])
        }
        
        let headers = [
            "Authorization": "Bearer \(SendGridConstants.apiKey)",
            "Content-Type": "application/json"
        ]
        
        // ✅ Call the async NetworkManager function (No Decoding Needed)
        try await networkManager.sendRequest(
            url: url,
            headers: headers,
            body: jsonData
        )
    }
}

