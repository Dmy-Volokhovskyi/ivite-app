import Foundation

protocol LaunchViewInterface: AnyObject {
}

final class LaunchPresenter: BasePresenter {
    private let interactor: LaunchInteractor
    let router: LaunchRouter
    weak var viewInterface: LaunchController?
    
    init(router: LaunchRouter, interactor: LaunchInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension LaunchPresenter: LaunchEventHandler {
    func viewDidLoad() {
    #warning("change back")
        let mainScreenController = MainScreenBuilder(serviceProvider: interactor.serviceProvider).make()
        
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
        
//        let mainScreenController = PreviewInviteBuilder(serviceProvider: interactor.serviceProvider).make(previewMode: true, creatorFlowModel: testCreatorFlowModel)
//        
//        let mainScreenController = PaymentBuilder(serviceProvider: interactor.serviceProvider).make()
        router.changeRoot(to: mainScreenController)
    }
}

extension LaunchPresenter: LaunchDataSource {
}

extension LaunchPresenter: LaunchInteractorDelegate {
}
