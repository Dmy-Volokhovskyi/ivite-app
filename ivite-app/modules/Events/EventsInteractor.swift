protocol EventsInteractorDelegate: AnyObject {
}

final class EventsInteractor: BaseInteractor {
    weak var delegate: EventsInteractorDelegate?
}
