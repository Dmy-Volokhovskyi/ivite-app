protocol EventDetailsInteractorDelegate: AnyObject {
}

final class EventDetailsInteractor: BaseInteractor {
    weak var delegate: EventDetailsInteractorDelegate?
    
    var eventDetailsViewModel: EventDetailsViewModel
    
    init(eventDetailsViewModel: EventDetailsViewModel, serviceProvider: ServiceProvider) {  self.eventDetailsViewModel = eventDetailsViewModel
        super.init(serviceProvider: serviceProvider)
    }
}
