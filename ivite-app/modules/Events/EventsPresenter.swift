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
            let testCreatorFlowModel = CreatorFlowModel(
                originalCanvas: Canvas(
                    size: Size(width: 800, height: 600),
                    numberOfLayers: 3,
                    content: []
                ),
                canvas: Canvas(
                    size: Size(width: 1024, height: 768),
                    numberOfLayers: 4,
                    content: [
                    ]
                ),
                eventDetailsViewModel: {
                    let eventDetails = EventDetailsViewModel()
                    eventDetails.eventTitle = "Birthday Bash"
                    eventDetails.date = Date()
                    eventDetails.timeZone = "PST"
                    eventDetails.hostName = "John Doe"
                    eventDetails.coHosts = [
                        CoHost(name: "Jane Smith", email: "jane.smith@example.com"),
                        CoHost(name: "David Johnson", email: "david.johnson@example.com")
                    ]
                    eventDetails.location = "San Francisco Convention Center"
                    eventDetails.city = "San Francisco"
                    eventDetails.state = "California"
                    eventDetails.zipCode = "94101"
                    eventDetails.note = "Bring your own drinks!"
                    eventDetails.isBringListActive = true
                    eventDetails.bringList = [
                        BringListItem(name: "Chips", count: 3),
                        BringListItem(name: "Soda", count: 5)
                    ]
                    return eventDetails
                }(),
                giftDetailsViewModel: {
                    let giftDetails = GiftDetailsViewModel()
                    giftDetails.gifts = [
                        Gift(name: "Wireless Headphones", link: "http://example.com/headphones", image: nil, gifterEmail: "alice@example.com"),
                        Gift(name: "Gift Card", link: "http://example.com/giftcard",
                             image: nil,
                             imageURL: URL(string: "https://static.wikia.nocookie.net/versus-compendium/images/0/00/Link_BotW.png/revision/latest?cb=20181128185543"))
                    ]
                    return giftDetails
                }(),
                guests: [
                    Guest(name: "Alice Wonderland", email: "alice@example.com", phone: "1234567890"),
                    Guest(name: "Bob Builder", email: "bob@example.com", phone: "9876543210")
                ]
            )
            
            self.router.showPreview(creatorFlowModel: testCreatorFlowModel, serviceProvider: self.interactor.serviceProvider)
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
    
    func eventCardModel(for indexPath: IndexPath) -> EventCardModel {
        interactor.eventCards[indexPath.section]
    }
    
    var numberOfRows: Int {
        1
    }
    
    var numberOfSections: Int {
        interactor.eventCards.count - 1
    }
}

extension EventsPresenter: EventsInteractorDelegate {
    func eventDownloadSuccess() {
        viewInterface?.reloadTableView()
    }
}
