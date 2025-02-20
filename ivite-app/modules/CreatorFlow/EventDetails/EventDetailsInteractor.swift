protocol EventDetailsDelegate: AnyObject {
    func didEndEventDetails(wasEditing: Bool)
}

protocol EventDetailsInteractorDelegate: AnyObject {
    func isReadyToSaveChanges(ready: Bool)
}

final class EventDetailsInteractor: BaseInteractor {
    weak var delegate: EventDetailsInteractorDelegate?
    weak var eventDetailsDelegate: EventDetailsDelegate?
    
    let isEditing: Bool
    var eventDetailsViewModel: EventDetailsViewModel
    
    init(eventDetailsViewModel: EventDetailsViewModel,
         eventDetailsDelegate: EventDetailsDelegate,
         isEditing: Bool,
         serviceProvider: ServiceProvider) {
        self.eventDetailsViewModel = eventDetailsViewModel
        self.isEditing = isEditing
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
