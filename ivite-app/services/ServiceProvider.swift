//
//  ServiceProvider.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import Foundation

class ServiceProvider {
    var authentificationService: AuthentificationService
    
    init(authentificationService: AuthentificationService) {
        self.authentificationService = authentificationService
    }
}
