protocol EventDetailsDelegate: AnyObject {
    func didEndEventDetails()
}

protocol EventDetailsInteractorDelegate: AnyObject {
}

final class EventDetailsInteractor: BaseInteractor {
    weak var delegate: EventDetailsInteractorDelegate?
    weak var eventDetailsDelegate: EventDetailsDelegate?
    
    var eventDetailsViewModel: EventDetailsViewModel
    
    init(eventDetailsViewModel: EventDetailsViewModel, eventDetailsDelegate: EventDetailsDelegate, serviceProvider: ServiceProvider) {
        self.eventDetailsViewModel = eventDetailsViewModel
        super.init(serviceProvider: serviceProvider)
        
        self.eventDetailsDelegate = eventDetailsDelegate
    }
}
