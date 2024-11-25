import Foundation

protocol EditGuestViewInterface: AnyObject {
}

final class EditGuestPresenter: BasePresenter {
    private let interactor: EditGuestInteractor
    let router: EditGuestRouter
    weak var viewInterface: EditGuestController?
    
    init(router: EditGuestRouter, interactor: EditGuestInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension EditGuestPresenter: EditGuestEventHandler {
    func editGuest(name: String, email: String) {
        interactor.guest.name = name
        interactor.guest.email = email
        interactor.editGuestDelegate?.didEditGuest(guest: interactor.guest)
        router.dismiss(completion: nil)
    }
}

extension EditGuestPresenter: EditGuestDataSource {
    var guest: Guest {
        interactor.guest
    }
}

extension EditGuestPresenter: EditGuestInteractorDelegate {
}
