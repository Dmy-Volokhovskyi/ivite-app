//
//  CreatorFlowNavigationController.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import Combine
import UIKit

enum EditOption {
    case mainDetails
    case gifting
    case addGuests
}

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
    weak var reviewRefreshDelegate: ReviewRefreshDelegate?
    
    private let urlString: String
    init(serviceProvider: ServiceProvider, urlString: String) {
        self.serviceProvider = serviceProvider
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        
#warning("Set up paywall non premium user == 1 draft.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushNextStep(for: nil)
        navigationBar.isHidden = false
    }
    
    func sendEmails() {
        Task {
            await serviceProvider.sendGridManager.sendEmails(to: [Guest(name: "Banaan", email: "nox8991@gmail.com", phone: "")], eventId: "2BA0CACE-D0E4-47EE-9AD1-8A56398B3B94", senderName: creatorFlowModel.eventDetailsViewModel.hostName ?? "")
        }
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
            configurationWizardDelegate?.didCompleteCreatorFlow()
            return
        }
        
        let controller: UIViewController
        switch nextStep {
        case .templateEditor:
            controller = TemplateEditorBuilder(serviceProvider: serviceProvider)
                .make(creatorFlowModel: creatorFlowModel, urlString: urlString, templateEditorDelegate: self)
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
            let tuple = ReviewBuilder(serviceProvider: serviceProvider).make(reviewDelegate: self, creatorFlowModel: creatorFlowModel)
            controller = tuple.0
            reviewRefreshDelegate = tuple.1
        }
        self.setupNavBar(for: nextStep, in: controller)
        // Push the view controller
        pushViewController(controller, animated: true)
        
        // Now set the navigation bar for the pushed controller
        DispatchQueue.main.async {
            self.setupNavBar(for: nextStep, in: controller)
        }
    }
    
    private func saveData(isDraft: Bool) {
        guard let image = creatorFlowModel.image else {
            print("No image found in CreatorFlowModel")
            return
        }
        
        let newEvent = Event(from: creatorFlowModel, status: isDraft ? .draft : .pending)
        let storagePath = "events/\(newEvent.id)/canvasImage.jpg"
        
        Task {
            do {
                // Step 1: Upload the image to Firebase Storage
                let imageURL = try await serviceProvider.firestoreManager.uploadImageToStorage(
                    image: image,
                    path: storagePath
                )
                
                print("Image uploaded successfully: \(imageURL)")
                
                // Step 2: Update the event model with the image URL
                var updatedEvent = newEvent
                updatedEvent.canvasImageURL = imageURL
                
                // Step 3: Save the event (excluding guests & gifts)
                try await serviceProvider.firestoreManager.saveEvent(updatedEvent)
                print("Event saved successfully with canvas image URL!")
                
                // Step 4: Save guests as a subcollection
                try await serviceProvider.firestoreManager.saveGuests(for: updatedEvent.id, guests: updatedEvent.guests)
                
                // Step 5: Save gifts as a subcollection
                try await serviceProvider.firestoreManager.saveGifts(for: updatedEvent.id, gifts: updatedEvent.gifts)
                
            } catch {
                print("Error saving event with canvas image: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func setupNavBar(for step: Step, in controller: UIViewController) {
        let currentIndex = Step.allCases.firstIndex(of: step) ?? 0
        let totalSteps = Step.allCases.count
        
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
        let saveToDraftsAction = ActionItem(title: "Save to drafts", image: nil, isPrimary: true) {
            self.saveData(isDraft: true)
            print("Saved to drafts tapped")
        }
        
        let exitWithoutSavingAction = ActionItem(title: "Exit without saving", image: nil, isPrimary: false) {
            self.presentingViewController?.dismiss(animated: true)
        }
        
        let alertItem = AlertItem(
            title: "Save to drafts",
            message: "Save your progress and continue editing later",
            actions: [saveToDraftsAction, exitWithoutSavingAction]
        )
        
        let alertVC = AlertViewController()
        alertVC.setAlertItem(alertItem)
        
        // Wrap AlertViewController in a ModalNavigationController
        let navigationController = ModalNavigationController(rootViewController: alertVC)
        navigationController.isFullScreen = false
        
        // Present the navigation controller
        self.present(navigationController, animated: true)
    }
}

extension CreatorFlowNavigationController: TemplateEditorDelegate {
    func didEndTemplateEdition(creatorFlowModel: CreatorFlowModel) {
        self.creatorFlowModel = creatorFlowModel
        pushNextStep(for: .templateEditor)
    }
}

extension CreatorFlowNavigationController: EventDetailsDelegate {
    func didEndEventDetails(wasEditing: Bool) {
        wasEditing ? reviewRefreshDelegate?.refreshReviewContent() : pushNextStep(for: .eventDetails)
    }
}

extension CreatorFlowNavigationController: GiftingOptionsDelegate {
    func didEndGiftingOptions(gifts: [Gift], wasEditing: Bool) {
        creatorFlowModel.giftDetailsViewModel.gifts = gifts
        wasEditing ? reviewRefreshDelegate?.refreshReviewContent() : pushNextStep(for: .giftingOptions)
    }
}

extension CreatorFlowNavigationController: AddGuestsDelegate {
    func didFinishAddGuests(with guests: [Guest], wasEditing: Bool) {
        creatorFlowModel.guests = guests
        wasEditing ? reviewRefreshDelegate?.refreshReviewContent() : pushNextStep(for: .addGuests)
    }
}

extension CreatorFlowNavigationController: ReviewDelegate {
    func reviewDidAskForEdit(editOption: EditOption) {
        let controller: UIViewController
        switch editOption {
        case .mainDetails:
            controller = EventDetailsBuilder(serviceProvider: serviceProvider)
                .make(eventDetailsDelegate: self,
                      eventDetailsViewModel: creatorFlowModel.eventDetailsViewModel,
                      isEditing: true)
        case .gifting:
            controller = GiftingOptionsBuilder(serviceProvider: serviceProvider)
                .make(gifts: creatorFlowModel.giftDetailsViewModel.gifts,
                      giftingOptionsDelegate: self,
                      isEditing: true)
        case .addGuests:
            controller = AddGuestsBuilder(serviceProvider: serviceProvider)
                .make(addGuestDelegate: self,
                      guests: creatorFlowModel.guests,
                      isEditing: true)
        }
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
    }
    
    func didEndReview() {
        saveData(isDraft: false)
    }
}

