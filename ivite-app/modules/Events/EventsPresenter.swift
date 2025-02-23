import Foundation

protocol EventsViewInterface: AnyObject {
    func reloadTableView()
}

final class EventsPresenter: BasePresenter {
    private let interactor: EventsInteractor
    let router: EventsRouter
    weak var viewInterface: EventsController?
    
    init(router: EventsRouter, interactor: EventsInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension EventsPresenter: EventsEventHandler {
    func createNewEventButtonTouch() {
        router.switchToTab(index: 0)
    }
    
    func didTouchMenu(for indexPath: IndexPath?) {
        // Define the actions
        let addGuestsAction = ActionItem(title: "Add guests", image: .guest, isPrimary: true) {
            print("Add guests pressed")
        }

        let editAction = ActionItem(title: "Edit", image: .edit, isPrimary: false) {
            print("Edit pressed")
        }

        let copyInvitationAction = ActionItem(title: "Copy Invitation", image: .copy, isPrimary: false) {
            print("Copy Invitation pressed")
        }

        let viewInvitationAction = ActionItem(title: "View Invitation", image: .eyeOpen, isPrimary: false) {
//            let testCreatorFlowModel = CreatorFlowModel
//            
//            self.router.showPreview(creatorFlowModel: testCreatorFlowModel, serviceProvider: self.interactor.serviceProvider)
            print("View Invitation pressed")
        }

        let deleteAction = ActionItem(title: "Delete", image: .trash, isPrimary: false) {
            print("Delete pressed")
        }

        // Use the router to display the actions
        router.showActions(actions: [
            addGuestsAction,
            editAction,
            copyInvitationAction,
            viewInvitationAction,
            deleteAction
        ])

    }
    
    func viewWillAppear() {
        interactor.checkForUserUpdates()
        viewInterface?.updateSearchBar()
    }
    
    func viewDidLoad() {
        interactor.getEvents()
    }
}

extension EventsPresenter: EventsDataSource {
    var user: IVUser? {
        interactor.currentUser
    }
    
    func eventCardModel(for indexPath: IndexPath) -> Event {
        interactor.eventCards[indexPath.section]
    }
    
    var numberOfRows: Int {
        1
    }
    
    var numberOfSections: Int {
        interactor.eventCards.count
    }
}

extension EventsPresenter: EventsInteractorDelegate {
    func eventDownloadSuccess() {
        viewInterface?.reloadTableView()
    }
}

