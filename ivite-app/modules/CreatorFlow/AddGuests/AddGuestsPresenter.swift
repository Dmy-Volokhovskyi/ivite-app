import Foundation

protocol AddGuestsViewInterface: AnyObject {
}

final class AddGuestsPresenter: BasePresenter {
    private let interactor: AddGuestsInteractor
    let router: AddGuestsRouter
    weak var viewInterface: AddGuestsController?
    
    init(router: AddGuestsRouter, interactor: AddGuestsInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension AddGuestsPresenter: AddGuestsEventHandler {
    func didTouchBackButton() {
        router.popVC()
    }
    
    func didTouchNextButton() {
        interactor.addGuestsDelegate?.didFinishAddGuests()
    }
}

extension AddGuestsPresenter: AddGuestsDataSource {
    var numberOfRows: Int {
        interactor.invitedGuests.count
    }
    
    func getAddedGuest(for indexPath: IndexPath) -> Guest {
        interactor.invitedGuests[indexPath.row]
    }
}

extension AddGuestsPresenter: AddGuestsInteractorDelegate {
}
