//
//  BaseInteractor.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import Foundation

protocol BaseInteractorDelegate: AnyObject {
}

class BaseInteractor {
    let serviceProvider: ServiceProvider
    
    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }
}
