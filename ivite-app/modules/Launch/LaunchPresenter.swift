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
        var people: [ContactCardModel] = [
            ContactCardModel(name: "John Smith", email: "john.smith@example.com", date: Date()),
            ContactCardModel(name: "Jane Doe", email: "jane.doe@example.com", date: Date()),
            ContactCardModel(name: "Uncle Bob", email: "uncle.bob@example.com", date: Date()),
            ContactCardModel(name: "Alice Johnson", email: "alice.j@example.com", date: Date()),
            ContactCardModel(name: "Bob Brown", email: "bob.brown@example.com", date: Date()),
            ContactCardModel(name: "Charlie Davis", email: "charlie.davis@example.com", date: Date()),
            ContactCardModel(name: "Dana White", email: "dana.white@example.com", date: Date())
        ]
        
        // Step 2: Create Groups and Assign Members
        let familyGroup = ContactGroup(name: "Family")
        let friendsGroup = ContactGroup(name: "Friends")
        let colleaguesGroup = ContactGroup(name: "Colleagues")
        
        // Assign members to groups
        familyGroup.members = [people[0], people[1], people[2]] // John, Jane, Uncle Bob
        friendsGroup.members = [people[3], people[4]]           // Alice, Bob
        colleaguesGroup.members = [people[5], people[6]]        // Charlie, Dana
        
        // Add group references to each contact
        people[0].addGroup(familyGroup)
        people[1].addGroup(familyGroup)
        people[2].addGroup(familyGroup)
        
        people[3].addGroup(friendsGroup)
        people[4].addGroup(friendsGroup)
        
        people[5].addGroup(colleaguesGroup)
        people[6].addGroup(colleaguesGroup)
        
        // Step 3: Create the Unified Test Data
        let testGroups: [ContactGroup] = [familyGroup, friendsGroup, colleaguesGroup]
        let testContacts: [ContactCardModel] = people
        
        let testGuestList: [Guest] = [
            Guest(id: people[0].id, name: people[0].name, email: people[0].email, phone: "123-456-7890", status: .confirmed),
            Guest(id: people[1].id, name: people[1].name, email: people[1].email, phone: "987-654-3210", status: .invited)
        ]

//        let mainScreenController = AdressBookBuilder(serviceProvider: interactor.serviceProvider).make(groups: testGroups, contacts: testContacts, guestList: testGuestList)
        router.changeRoot(to: mainScreenController)
    }
}

extension LaunchPresenter: LaunchDataSource {
}

extension LaunchPresenter: LaunchInteractorDelegate {
}
