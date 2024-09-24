//
//  BaseBuilder.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import UIKit

class BaseBuilder {
    let serviceProvider: ServiceProvider
    
    required init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }
    
    func make() -> UIViewController {
        fatalError("\(#function) must be overriden")
    }
}
