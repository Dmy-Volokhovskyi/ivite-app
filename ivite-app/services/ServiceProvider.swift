//
//  ServiceProvider.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import Foundation

class ServiceProvider {
    var authenticationService: AuthenticationService
    var userDefaultsService: UserDefaultsService
    
    init(authenticationService: AuthenticationService, userDefaultsService: UserDefaultsService) {
        self.authenticationService = authenticationService
        self.userDefaultsService = userDefaultsService
    }
}
