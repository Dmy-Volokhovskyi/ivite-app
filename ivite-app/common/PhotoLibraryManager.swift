//
//  PhotoLibraryManager.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 03/11/2024.
//


import Photos

import Photos
import UIKit

class PhotoLibraryManager: NSObject, UINavigationControllerDelegate {
    static let shared = PhotoLibraryManager()
    
    private var completion: ((UIImage?) -> Void)?

    func requestPhotoLibraryAccess(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) async {
        let isAuthorized = await checkPhotoLibraryAuthorization()
        
        if isAuthorized {
            presentImagePicker(from: viewController, completion: completion)
        } else {
            showAccessDeniedAlert(on: viewController)
        }
    }

    // Private method to check authorization status asynchronously
    private func checkPhotoLibraryAuthorization() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization { newStatus in
                    continuation.resume(returning: newStatus == .authorized)
                }
            }
        default:
            return false
        }
    }

    // Presents the image picker controller
    private func presentImagePicker(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        viewController.present(imagePickerController, animated: true)
    }

    // Show an alert if access is denied
    private func showAccessDeniedAlert(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Access Denied",
            message: "Please enable photo library access in settings to add images.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }

}

extension PhotoLibraryManager: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        completion?(selectedImage)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion?(nil)
        picker.dismiss(animated: true)
    }
}
