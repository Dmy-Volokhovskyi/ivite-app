import Foundation

protocol ContactInteractorDelegate: AnyObject {
    func contactDownloadSuccess()
}

final class ContactInteractor: BaseInteractor {
    var contactCards = [ContactCardModel]()
    weak var delegate: ContactInteractorDelegate?
    
    func getContacts() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let mockContactCards: [ContactCardModel] = [
            ContactCardModel(
                name: "John Smith",
                email: "john.smith@example.com",
                date: dateFormatter.date(from: "21.01.2024") ?? Date(),
                group: "No group"
            ),
            ContactCardModel(
                name: "Jane Doe",
                email: "jane.doe@example.com",
                date: dateFormatter.date(from: "15.02.2024") ?? Date(),
                group: "Friends"
            ),
            ContactCardModel(
                name: "Emily Johnson",
                email: "emily.johnson@example.com",
                date: dateFormatter.date(from: "10.03.2024") ?? Date(),
                group: "Work"
            ),
            ContactCardModel(
                name: "Michael Brown",
                email: "michael.brown@example.com",
                date: dateFormatter.date(from: "05.04.2024") ?? Date(),
                group: "Family"
            )
        ]
        contactCards = mockContactCards
    }
}
