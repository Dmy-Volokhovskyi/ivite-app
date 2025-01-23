import Foundation

protocol HomeViewInterface: AnyObject {
    func didSignIn()
    func updateSearchBar()
    func reloadCollectionView()
}

final class HomePresenter: BasePresenter {
    private let interactor: HomeInteractor
    let router: HomeRouter
    weak var viewInterface: HomeController?
    
    private var allTemplates: [Template] = [] // Unfiltered templates
    private var filteredTemplates: [Template] = [] // Filtered templates
    
    private var selectedCategory: TemplateCategory?
    private var searchText: String?
    
    init(router: HomeRouter, interactor: HomeInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    func showError(_ message: String) {
        router.showSystemAlert(
            title: "Error",
            message: message
        )
    }
    
    private func applyFilters() {
        filteredTemplates = allTemplates
        
        // Apply category filter
        if let category = selectedCategory {
            filteredTemplates = filteredTemplates.filter { $0.category == category }
        }
        
        // Apply search text filter
        if let text = searchText, !text.isEmpty {
            filteredTemplates = filteredTemplates.filter { $0.name.localizedCaseInsensitiveContains(text) }
        }
        
        // Notify view to reload data
        viewInterface?.reloadCollectionView()
    }
}

extension HomePresenter: HomeEventHandler {
    func viewDidLoad() {
        Task {
            do {
                try await interactor.fetchTemplates()
            } catch {
                router.showSystemAlert(title: "Failed to load templates", message: error.localizedDescription)
            }
        }
    }
    
    func viewWillAppear() {
        interactor.checkForUserUpdates()
        viewInterface?.updateSearchBar()
    }
    
    func didTapLogInButton() {
        router.showSignIn(serviceProvider: interactor.serviceProvider)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        router.switchToCreatorFlow(urlString: filteredTemplates[indexPath.item].detailsURL, serviceProvider: interactor.serviceProvider)
    }

    func updateCategoryFilter(_ category: TemplateCategory?) {
        selectedCategory = category
        applyFilters()
    }
    
    func updateSearchText(_ text: String?) {
        searchText = text
        applyFilters()
    }
}

extension HomePresenter: HomeDataSource {
    var templateCount: Int {
        filteredTemplates.count
    }
    
    var categories: [TemplateCategory] {
        TemplateCategory.allCases
    }
    
    func templateModelForItem(at indexPath: IndexPath) -> Template {
        filteredTemplates[indexPath.item]
    }
    
    var user: IVUser? {
        interactor.currentUser
    }
}

extension HomePresenter: HomeInteractorDelegate {
    func didFetchTemplates(templates: [Template]) {
        allTemplates = templates
        applyFilters()
    }
    
    func didFetchTemplates() {
        viewInterface?.reloadCollectionView()
    }
    
    func didFailFetchingTemplates(_ error: any Error) {
        router.showSystemAlert(title: "Failed to load templates", message: error.localizedDescription)
    }
}
