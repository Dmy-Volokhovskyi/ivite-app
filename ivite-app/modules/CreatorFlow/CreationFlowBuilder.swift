//
//  CreationFlowBuilder.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import Foundation

final class ConfigurationWizardBuilder: BaseBuilder {
    override func make() -> CreatorFlowNavigationController {
        let navigationController = CreatorFlowNavigationController(serviceProvider: serviceProvider)
        
        #warning("Change back")
        let controller = EventDetailsBuilder(serviceProvider: serviceProvider)
            .make(eventDetailsViewModel: EventDetailsViewModel())
//        let controller = TemplateEditorBuilder(serviceProvider: serviceProvider).make(templateEditorDelegate: navigationController)
        
        navigationController.viewControllers = [controller]
        
        return navigationController
    }
}
