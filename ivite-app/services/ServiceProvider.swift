//
//  ServiceProvider.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import Foundation
import FirebaseFirestore

class ServiceProvider {
    var authenticationService: AuthenticationService
    var userDefaultsService: UserDefaultsService
    var firestoreManager: FirestoreManager
    var fontManager: FontManager
    var sendGridManager: SendGridManager
    
    init(authenticationService: AuthenticationService,
         userDefaultsService: UserDefaultsService,
         firestore: Firestore,
         sendGridManager: SendGridManager) {
        
        self.authenticationService = authenticationService
        self.userDefaultsService = userDefaultsService
        self.firestoreManager = FirestoreManager(db: firestore, userDefaultsService: userDefaultsService)
        self.fontManager = FontManager(urlProvider: GoogleFontsURLProvider())
        self.sendGridManager = sendGridManager
    }
}
