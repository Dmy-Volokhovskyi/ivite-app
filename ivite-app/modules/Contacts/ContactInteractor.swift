import Foundation

protocol ContactInteractorDelegate: AnyObject {
    func contactDownloadSuccess()
}

final class ContactInteractor: BaseInteractor {
    var contactCards = [ContactCardModel]()
    var groups: [ContactGroup] = []
    
    weak var delegate: ContactInteractorDelegate?
    
    func getContacts() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        // Create groups
        let noGroup = ContactGroup(name: "No group")
        let friendsGroup = ContactGroup(name: "Friends")
        let workGroup = ContactGroup(name: "Work")
        let familyGroup = ContactGroup(name: "Family")
        
        // Create test contacts
        let testContacts = [
            ContactCardModel(
                name: "John Smith",
                email: "john.smith@example.com",
                date: dateFormatter.date(from: "21.01.2024") ?? Date(),
                groups: [noGroup]
            ),
            ContactCardModel(
                name: "Jane Doe",
                email: "jane.doe@example.com",
                date: dateFormatter.date(from: "15.02.2024") ?? Date(),
                groups: [friendsGroup]
            ),
            ContactCardModel(
                name: "Emily Johnson",
                email: "emily.johnson@example.com",
                date: dateFormatter.date(from: "10.03.2024") ?? Date(),
                groups: [workGroup]
            ),
            ContactCardModel(
                name: "Michael Brown",
                email: "michael.brown@example.com",
                date: dateFormatter.date(from: "05.04.2024") ?? Date(),
                groups: [familyGroup]
            )
        ]
        
        // Add the contacts to their respective groups
        noGroup.addMember(testContacts[0])
        friendsGroup.addMember(testContacts[1])
        workGroup.addMember(testContacts[2])
        familyGroup.addMember(testContacts[3])
        
        groups.append(contentsOf: [noGroup, friendsGroup, workGroup, familyGroup])
        
        contactCards = testContacts
        delegate?.contactDownloadSuccess()
    }
    
    func removeGroup(group: ContactGroup) {
        contactCards.forEach( {
            $0.removeGroup(group)
        })
        groups.removeAll(where: { $0.id == group.id })
    }
}
