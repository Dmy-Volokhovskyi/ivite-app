//
//  UIApplication+AppDelegate.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import UIKit

extension UIApplication {
    var appDelegate: AppDelegate? {
        self.delegate as? AppDelegate
    }
}

extension UIApplication {
    var sceneDelegate: SceneDelegate? {
        connectedScenes.first?.delegate as? SceneDelegate
    }
}
