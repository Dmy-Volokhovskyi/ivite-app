import Foundation

protocol EventsInteractorDelegate: AnyObject {
    func eventDownloadSuccess()
}

final class EventsInteractor: BaseInteractor {
    var eventCards = [Event]()
    weak var delegate: EventsInteractorDelegate?
    
    var currentUser: IVUser?
    
    override init(serviceProvider: ServiceProvider) {
        super.init(serviceProvider: serviceProvider)
        
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
    
    func checkForUserUpdates() {
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
    
    func getEvents() {
        Task {
            do {
                // Fetch events from Firestore
                let events = try await serviceProvider.firestoreManager.fetchAllEvents()
                print(events, "events")
                // Notify the delegate
                eventCards = events
                DispatchQueue.main.async {
                    self.delegate?.eventDownloadSuccess()
                }
            } catch {
                print("Failed to fetch events: \(error)")
            }
        }
    }
}
