//
//  CreationFlowBuilder.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import Foundation

final class ConfigurationWizardBuilder: BaseBuilder {
    func make(urlString: String) -> CreatorFlowNavigationController {
        let navigationController = CreatorFlowNavigationController(serviceProvider: serviceProvider, urlString: urlString)
        
//        let controller = TemplateEditorBuilder(serviceProvider: serviceProvider).make(creatorFlowModel: creatorFlowModel, urlString: urlString, templateEditorDelegate: navigationController)
//        
//        navigationController.viewControllers = [controller]
        
        return navigationController
    }
}
