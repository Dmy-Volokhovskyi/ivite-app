import Foundation

protocol PastGuestListDelegate: AnyObject {
    func didFinishPicking(with guests: [Guest])
}

protocol PastGuestListInteractorDelegate: AnyObject {
    func eventDownloadSuccess()
}

final class PastGuestListInteractor: BaseInteractor {
    weak var delegate: PastGuestListInteractorDelegate?
    weak var pastListDelegate: PastGuestListDelegate?
    
    var events: [Event] = []
    var selectedEvents: [String: Event] = [:]
    
    override init(serviceProvider: ServiceProvider) {
        super.init(serviceProvider: serviceProvider)
    }
    
    func getEvents() {
        Task {
            do {
                // Fetch events from Firestore
                let events = try await serviceProvider.firestoreManager.fetchAllEventsWithGuests()
                print(events, "events")
                // Notify the delegate
                self.events = events
                DispatchQueue.main.async {
                    self.delegate?.eventDownloadSuccess()
                }
            } catch {
                print("Failed to fetch events: \(error)")
            }
        }
    }
    
    func isEventSelected(_ id: String) -> Bool {
        return selectedEvents.keys.contains(id)
    }
    
}
