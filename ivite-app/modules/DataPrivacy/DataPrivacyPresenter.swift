import Foundation

protocol DataPrivacyViewInterface: AnyObject {
}

final class DataPrivacyPresenter: BasePresenter {
    private let interactor: DataPrivacyInteractor
    let router: DataPrivacyRouter
    weak var viewInterface: DataPrivacyController?
    
    init(router: DataPrivacyRouter, interactor: DataPrivacyInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension DataPrivacyPresenter: DataPrivacyEventHandler {
    func viewWillAppear() {
        print("DataPrivacy")
    }
}

extension DataPrivacyPresenter: DataPrivacyDataSource {
}

extension DataPrivacyPresenter: DataPrivacyInteractorDelegate {
}
