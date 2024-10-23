import Foundation

protocol LaunchViewInterface: AnyObject {
}

final class LaunchPresenter: BasePresenter {
    private let interactor: LaunchInteractor
    let router: LaunchRouter
    weak var viewInterface: LaunchController?
    
    init(router: LaunchRouter, interactor: LaunchInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension LaunchPresenter: LaunchEventHandler {
    func viewDidLoad() {
    #warning("change back")
//        let mainScreenController = MainScreenBuilder(serviceProvider: interactor.serviceProvider).make()
//        let mainScreenController = ConfigurationWizardBuilder(serviceProvider: interactor.serviceProvider).make()
        
        let mainScreenController = SignInBuilder(serviceProvider: interactor.serviceProvider).make()
        router.changeRoot(to: mainScreenController)
    }
}

extension LaunchPresenter: LaunchDataSource {
}

extension LaunchPresenter: LaunchInteractorDelegate {
}
