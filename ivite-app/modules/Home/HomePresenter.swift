import Foundation

protocol HomeViewInterface: AnyObject {
    func didSignIn()
    func updateSearchBar()
}

final class HomePresenter: BasePresenter {
    private let interactor: HomeInteractor
    let router: HomeRouter
    weak var viewInterface: HomeController?
    
    init(router: HomeRouter, interactor: HomeInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension HomePresenter: HomeEventHandler {
    func viewWillAppear() {
        interactor.checkForUserUpdates()
        viewInterface?.updateSearchBar()
    }
    
    func didTapLogInButton() {
        router.showSignIn(serviceProvider: interactor.serviceProvider)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        router.switchToCreatorFlow(serviceProvider: interactor.serviceProvider)
    }
}

extension HomePresenter: HomeDataSource {
    var user: IVUser? {
        interactor.currentUser
    }
}

extension HomePresenter: HomeInteractorDelegate {
}
