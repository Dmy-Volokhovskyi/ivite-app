import Foundation

protocol ContactViewInterface: AnyObject {
    func reloadTableView()
}

final class ContactPresenter: BasePresenter {
    private let interactor: ContactInteractor
    let router: ContactRouter
    weak var viewInterface: ContactController?
    
    init(router: ContactRouter, interactor: ContactInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ContactPresenter: ContactEventHandler {
    func didTouchMenu(for indexPath: IndexPath?) {
        print("open MENU!")
    }

    func viewDidLoad() {
        interactor.getContacts()
    }
}

extension ContactPresenter: ContactDataSource {
    func contactCardModel(for indexPath: IndexPath) -> ContactCardModel {
        interactor.contactCards[indexPath.section]
    }
    
    var numberOfRows: Int {
        1
    }
    
    var numberOfSections: Int {
        interactor.contactCards.count - 1
    }
}

extension ContactPresenter: ContactInteractorDelegate {
    func contactDownloadSuccess() {
        viewInterface?.reloadTableView()
    }
}
