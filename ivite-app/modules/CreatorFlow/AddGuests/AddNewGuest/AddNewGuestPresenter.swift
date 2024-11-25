import Foundation

protocol AddNewGuestViewInterface: AnyObject {
}

final class AddNewGuestPresenter: BasePresenter {
    private let interactor: AddNewGuestInteractor
    let router: AddNewGuestRouter
    weak var viewInterface: AddNewGuestController?
    
    init(router: AddNewGuestRouter, interactor: AddNewGuestInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension AddNewGuestPresenter: AddNewGuestEventHandler {
    func addGuest(name: String, email: String) {
        interactor.addNewGuestDelgate?.didAddNewGuest(gueast: Guest(name: name, email: email, phone: ""))
        router.popVC()
    }
}

extension AddNewGuestPresenter: AddNewGuestDataSource {
}

extension AddNewGuestPresenter: AddNewGuestInteractorDelegate {
}
