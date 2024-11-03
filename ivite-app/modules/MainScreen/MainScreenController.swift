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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar1()  // Call setupTabBar in viewDidLoad
    }
    
    func setupTabBar1() {
        let homeController = HomeBuilder(serviceProvider: dataSource.serviceProvider).make()
        let homeNavController = UINavigationController(rootViewController: homeController)
        let eventController = EventsBuilder(serviceProvider: dataSource.serviceProvider).make()
        let contactsController = ContactBuilder(serviceProvider: dataSource.serviceProvider).make()
        let profileController = ProfileBuilder(serviceProvider: dataSource.serviceProvider).make()
        let profileNavController = UINavigationController(rootViewController: profileController)
        // Assign titles and icons for the tab bar items
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: .home, tag: 0)
        eventController.tabBarItem = UITabBarItem(title: "Events", image: .events, tag: 1)
        contactsController.tabBarItem = UITabBarItem(title: "Contacts", image: .contacts, tag: 2)
        profileController.tabBarItem = UITabBarItem(title: "Profile", image: .profile, tag: 3)  // Updated the tag here
        
        self.viewControllers = [homeNavController, eventController, contactsController, profileNavController]
        setUpTabBarVisibility()
    }
    
    public func setUpTabBarVisibility() {
        if dataSource.serviceProvider.authentificationService.authenticationState == .authenticated {
            tabBar.isHidden = false
        } else {
            tabBar.isHidden = true
        }
    }
    
    @objc private func handleAuthStateChange(_ notification: Notification) {
        // Access authState directly from userInfo
        if let authState = notification.userInfo?["authState"] as? AuthenticationState {
            switch authState {
            case .authenticated:
                tabBar.isHidden = false
            case .unauthenticated:
                self.selectedIndex = 0
                tabBar.isHidden = true
            default:
                break
            }
        }
    }
    
    @objc private func handleValidationStateChange() {
        // Respond to changes in validation state if needed
        let isValid = dataSource.serviceProvider.authentificationService.isValid
        // Use `isValid` as needed in the view controller
    }
}

extension MainScreenController: MainScreenViewInterface {
}
