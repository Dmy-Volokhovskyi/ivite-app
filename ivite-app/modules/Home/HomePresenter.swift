import Foundation

protocol HomeViewInterface: AnyObject {
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
}

extension HomePresenter: HomeDataSource {
}

extension HomePresenter: HomeInteractorDelegate {
}
