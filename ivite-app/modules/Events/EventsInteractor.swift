import Foundation
protocol EventsInteractorDelegate: AnyObject {
    func eventDownloadSuccess()
}

final class EventsInteractor: BaseInteractor {
    var eventCards = [EventCardModel]()
    weak var delegate: EventsInteractorDelegate?
    
    func getEvents() {
        // Sample date formatter to create date objects
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, yyyy"

        // Creating sample card data
        let testCards: [EventCardModel] = [
            EventCardModel(
                imageName: "testImageCover",
                title: "Happy Birthday",
                date: dateFormatter.date(from: "Tue Jan 23, 2024") ?? Date(),
                status: "Delivered",
                statusColor: .gray
            ),
            EventCardModel(
                imageName: "testImageCover2",
                title: "Anniversary Celebration",
                date: dateFormatter.date(from: "Fri Feb 14, 2024") ?? Date(),
                status: "Pending",
                statusColor: .orange
            ),
            EventCardModel(
                imageName: "testImageCover3",
                title: "Team Meeting",
                date: dateFormatter.date(from: "Mon Mar 10, 2024") ?? Date(),
                status: "Scheduled",
                statusColor: .blue
            ),
            EventCardModel(
                imageName: "testImageCover4",
                title: "Family Reunion",
                date: dateFormatter.date(from: "Sat Apr 1, 2024") ?? Date(),
                status: "Completed",
                statusColor: .green
            )
        ]
        eventCards = testCards
        delegate?.eventDownloadSuccess()
    }
}
