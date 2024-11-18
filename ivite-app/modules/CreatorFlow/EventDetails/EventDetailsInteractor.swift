protocol EventDetailsDelegate: AnyObject {
    func didEndEventDetails()
}

protocol EventDetailsInteractorDelegate: AnyObject {
    func isReadyToSaveChanges(ready: Bool)
}

final class EventDetailsInteractor: BaseInteractor {
    weak var delegate: EventDetailsInteractorDelegate?
    weak var eventDetailsDelegate: EventDetailsDelegate?
    
    var eventDetailsViewModel: EventDetailsViewModel
    
    init(eventDetailsViewModel: EventDetailsViewModel, eventDetailsDelegate: EventDetailsDelegate, serviceProvider: ServiceProvider) {
        self.eventDetailsViewModel = eventDetailsViewModel
        super.init(serviceProvider: serviceProvider)
        eventDetailsViewModel.delegate = self
        self.eventDetailsDelegate = eventDetailsDelegate
    }
}

extension EventDetailsInteractor: EventDetailsViewModelDelegate {
    func isReadyToSaveChanged(to value: Bool) {
        delegate?.isReadyToSaveChanges(ready: value)
    }
}
