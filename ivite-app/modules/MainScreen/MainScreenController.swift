import UIKit

protocol MainScreenEventHandler: AnyObject {
}

protocol MainScreenDataSource: AnyObject {
    var serviceProvider: ServiceProvider { get }
}

final class MainScreenController: BaseTabBarController {
    private let eventHandler: MainScreenEventHandler
    private let dataSource: MainScreenDataSource
    
    init(eventHandler: MainScreenEventHandler, dataSource: MainScreenDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAuthStateChange),
                                               name: .authStateDidChange,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleValidationStateChange),
                                               name: .validationStateDidChange,
                                               object: nil)
        
        // Replace the tab bar with RoundedTabBar
        let roundedTabBar = RoundedTabBar()
        setValue(roundedTabBar, forKey: "tabBar")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupTabBar() {
        super.setupTabBar()
        
        let homeController = HomeBuilder(serviceProvider: dataSource.serviceProvider).make()
        let homeNavController = UINavigationController(rootViewController: homeController)
        let eventController = EventsBuilder(serviceProvider: dataSource.serviceProvider).make()
        let eventNavController = UINavigationController(rootViewController: eventController)
        let contactsController = ContactBuilder(serviceProvider: dataSource.serviceProvider).make()
        let profileController = ProfileBuilder(serviceProvider: dataSource.serviceProvider).make()
        let profileNavController = UINavigationController(rootViewController: profileController)
        
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: .home, tag: 0)
        eventController.tabBarItem = UITabBarItem(title: "Events", image: .events, tag: 1)
        contactsController.tabBarItem = UITabBarItem(title: "Contacts", image: .contacts, tag: 2)
        profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: .profile, tag: 3)
        
        self.viewControllers = [homeNavController, eventNavController, contactsController, profileNavController]

        setUpTabBarVisibility()
    }
    
    public func setUpTabBarVisibility() {
        tabBar.isHidden = dataSource.serviceProvider.authenticationService.authenticationState != .authenticated
    }
    
    @objc private func handleAuthStateChange(_ notification: Notification) {
        if let authState = notification.userInfo?["authState"] as? AuthenticationState {
            DispatchQueue.main.async { [weak self] in
                switch authState {
                case .authenticated:
                    self?.tabBar.isHidden = false
                case .unauthenticated:
                    self?.selectedIndex = 0
                    self?.tabBar.isHidden = true
                default:
                    break
                }
            }
        }
    }
    
    @objc private func handleValidationStateChange() {
        let isValid = dataSource.serviceProvider.authenticationService.isValid
        // Respond to validation changes
    }
}

extension MainScreenController: MainScreenViewInterface {}

