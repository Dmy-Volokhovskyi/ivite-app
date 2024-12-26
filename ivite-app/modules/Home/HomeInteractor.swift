protocol HomeInteractorDelegate: AnyObject {
}

final class HomeInteractor: BaseInteractor {
    weak var delegate: HomeInteractorDelegate?
    
    var currentUser: IVUser?
    
    override init(serviceProvider: ServiceProvider) {
        super.init(serviceProvider: serviceProvider)
        
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
    
    func checkForUserUpdates() {
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
}
