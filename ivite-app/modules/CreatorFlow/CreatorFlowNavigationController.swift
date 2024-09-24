//
//  CreatorFlowNavigationController.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import Combine
import UIKit

protocol CreatorFlowDelegate: AnyObject {
    func didCompleteCreatorFlow()
}

final class CreatorFlowNavigationController: UINavigationController {
    enum Step: CaseIterable {
        case templateEditor
    }
    
    private let serviceProvider: ServiceProvider
    private let configurationModel = CreatorFlowModel()
    weak var configurationWizardDelegate: CreatorFlowDelegate?
    
    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
    }
}

private extension CreatorFlowNavigationController {
    func nextStepAfter(_ step: Step?) -> Step? {
        guard let step, let index = Step.allCases.firstIndex(of: step) else { return Step.allCases.first }
        
        if index + 1 < Step.allCases.count {
            return Step.allCases[index + 1]
        } else {
            return nil
        }
    }
    
    func pushNextStep(for step: Step?) {
        guard let nextStep = nextStepAfter(step) else {
            saveData()
            configurationWizardDelegate?.didCompleteCreatorFlow()
            return
        }
        
        let controller: UIViewController
        
        switch nextStep {
            case .templateEditor:
            controller = TemplateEditorBuilder(serviceProvider: serviceProvider)
                    .make(templateEditorDelegate: self)
        default:
            controller = UIViewController()
        }
        
        pushViewController(controller, animated: true)
    }
    
    private func saveData() {
//        serviceProvider.database.updateProvincesSubscription(for: configurationModel.selectedProvinces)
//        serviceProvider.database.updateCategoriesVisibility(for: configurationModel.selectedCategories)
//        
//        serviceProvider.userDefaults.storeGeolocalization(configurationModel.isGeolocationOn)
//        serviceProvider.userDefaults.storePushNotifications(configurationModel.isNotificationsOn)
//        
//        serviceProvider.userDefaults.storeSetupOnceCompleted(true)
    }
}

extension CreatorFlowNavigationController: TemplateEditorDelegate {
    func didStartCreator() {
        pushNextStep(for: .templateEditor)
    }
    
    func didCancelCreator() {
        configurationWizardDelegate?.didCompleteCreatorFlow()
    }
}
