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
        case eventDetails
        case giftingOptions
        case addGuests
        case review
    }
    
    private let serviceProvider: ServiceProvider
    private var creatorFlowModel = CreatorFlowModel()
    weak var configurationWizardDelegate: CreatorFlowDelegate?
    
    private let urlString: String
    init(serviceProvider: ServiceProvider, urlString: String) {
        self.serviceProvider = serviceProvider
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupNavBar(for: .templateEditor)
        pushNextStep(for: nil)
        navigationBar.isHidden = false
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
                .make(templateEditorDelegate: self, urlString: urlString)
        case .eventDetails:
            controller = EventDetailsBuilder(serviceProvider: serviceProvider)
                .make(eventDetailsDelegate: self,
                      eventDetailsViewModel: creatorFlowModel.eventDetailsViewModel)
        case .giftingOptions:
            controller = GiftingOptionsBuilder(serviceProvider: serviceProvider)
                .make(gifts: creatorFlowModel.giftDetailsViewModel.gifts, giftingOptionsDelegate: self)
        case .addGuests:
            controller = AddGuestsBuilder(serviceProvider: serviceProvider).make(addGuestDelegate: self, guests: creatorFlowModel.guests)
        case .review:
            controller = ReviewBuilder(serviceProvider: serviceProvider).make(reviewDelegate: self, creatorFlowModel: creatorFlowModel)
        }
        self.setupNavBar(for: nextStep, in: controller)
        // Push the view controller
        pushViewController(controller, animated: true)
        
        // Now set the navigation bar for the pushed controller
        DispatchQueue.main.async {
            self.setupNavBar(for: nextStep, in: controller)
        }
    }
    
    
    private func saveData() {
    }
    
    private func setupNavBar(for step: Step, in controller: UIViewController) {
        let currentIndex = Step.allCases.firstIndex(of: step) ?? 0
        let totalSteps = Step.allCases.count
        let title = "\(currentIndex + 1) of \(totalSteps): \(navBarTitle(for: step))"
        
        // Optionally, set titleView if you want a custom UILabel
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.interFont(ofSize: 16, weight: .bold, italic: false),
            .foregroundColor: UIColor.secondary1
        ]
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.interFont(ofSize: 16, weight: .bold, italic: false),
            .foregroundColor: UIColor.dark30
        ]
        
        let mutableTitle = NSMutableAttributedString(string: "\(currentIndex + 1) of \(totalSteps): ", attributes: subtitleAttributes)
        mutableTitle.append(NSAttributedString(string: navBarTitle(for: step), attributes: titleAttributes))
        
        let label = UILabel()
        label.attributedText = mutableTitle
        label.textAlignment = .center
        
        // Assign the custom label to the navigationItem.titleView of the passed controller
        controller.navigationItem.titleView = label
        
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close,
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(closeButtonTouch))
        
    }
    
    
    private func navBarTitle(for step: Step) -> String {
        // Updated step names based on the new enum
        switch step {
        case .templateEditor:
            return "Edit Template"
        case .eventDetails:
            return "Event Details"
        case .giftingOptions:
            return "Gifting Options"
        case .addGuests:
            return "Add Guests"
        case .review:
            return "Review & Finish"
        }
    }
    
    @objc private func closeButtonTouch(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

extension CreatorFlowNavigationController: TemplateEditorDelegate {
    func didEndTemplateEdition() {
        pushNextStep(for: .templateEditor)
    }
}

extension CreatorFlowNavigationController: EventDetailsDelegate {
    func didEndEventDetails() {
        pushNextStep(for: .eventDetails)
    }
}

extension CreatorFlowNavigationController: GiftingOptionsDelegate {
    func didEndGiftingOptions(gifts: [Gift]) {
        creatorFlowModel.giftDetailsViewModel.gifts = gifts
        pushNextStep(for: .giftingOptions)
    }
}

extension CreatorFlowNavigationController: AddGuestsDelegate {
    func didFinishAddGuests(with guests: [Guest]) {
        creatorFlowModel.guests = guests
        pushNextStep(for: .addGuests)
    }
}

extension CreatorFlowNavigationController: ReviewDelegate {
    func didEndReview() {
        print("OK")
    }
}
