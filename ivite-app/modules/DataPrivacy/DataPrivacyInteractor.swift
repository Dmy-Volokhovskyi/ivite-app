protocol DataPrivacyInteractorDelegate: AnyObject {
}

final class DataPrivacyInteractor: BaseInteractor {
    weak var delegate: DataPrivacyInteractorDelegate?
}
