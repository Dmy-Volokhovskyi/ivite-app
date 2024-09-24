//
//  UserImageLibraryManager.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 05/10/2024.
//

import Foundation
import Photos

class UserImageLibraryManager {
    
    func requestAccessIfNeeded(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        @unknown default:
            completion(false)
        }
    }
}
