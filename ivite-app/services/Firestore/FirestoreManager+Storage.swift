//
//  FirestoreManager+Storage.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 27/01/2025.
//

import UIKit

import FirebaseStorage

extension FirestoreManager {
    func uploadImageToStorage(
        image: UIImage,
        path: String,
        compressionQuality: CGFloat = 0.8
    ) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            throw NSError(domain: "com.app.firestore", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unable to compress image"])
        }
        
        // Firebase Storage reference
        let storageRef = Storage.storage().reference().child(path)
        
        // Upload the image
        _ = try await storageRef.putDataAsync(imageData)
        
        // Get the download URL
        return try await storageRef.downloadURL().absoluteString
    }
}
