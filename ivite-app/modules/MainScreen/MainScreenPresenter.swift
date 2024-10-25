import Foundation

protocol MainScreenViewInterface: AnyObject {
}

final class MainScreenPresenter {
    private let interactor: MainScreenInteractor
    let router: MainScreenRouter
    weak var viewInterface: MainScreenController?
    
    init(router: MainScreenRouter, interactor: MainScreenInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension MainScreenPresenter: MainScreenEventHandler {
}

extension MainScreenPresenter: MainScreenDataSource {
    var serviceProvider: ServiceProvider {
        interactor.serviceProvider
    }
}

extension MainScreenPresenter: MainScreenInteractorDelegate {
}
