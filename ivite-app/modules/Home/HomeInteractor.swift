protocol HomeInteractorDelegate: AnyObject {
    func didFetchTemplates(templates: [Template])
    func didFailFetchingTemplates(_ error: Error)
}

final class HomeInteractor: BaseInteractor {
    weak var delegate: HomeInteractorDelegate?
    
    var currentUser: IVUser?
    var templates: [Template] = []
    
    override init(serviceProvider: ServiceProvider) {
        super.init(serviceProvider: serviceProvider)
        
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
    
    func checkForUserUpdates() {
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
    
    func fetchTemplates() async throws {
        do {
            templates = try await serviceProvider.firestoreManager.fetchTemplates()
            delegate?.didFetchTemplates(templates: templates)
        } catch {
            delegate?.didFailFetchingTemplates(error)
        }
    }
}
