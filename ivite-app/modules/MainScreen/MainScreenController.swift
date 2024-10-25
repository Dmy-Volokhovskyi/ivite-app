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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        // Assign titles and icons for the tab bar items
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: .home, tag: 0)
        eventController.tabBarItem = UITabBarItem(title: "Events", image: .events, tag: 1)
        contactsController.tabBarItem = UITabBarItem(title: "Contacts", image: .contacts, tag: 2)
        profileController.tabBarItem = UITabBarItem(title: "Profile", image: .profile, tag: 3)  // Updated the tag here
        
        self.viewControllers = [homeNavController, eventController, contactsController, profileController]
        setUpTabBarVisibility()
    }
    
    public func setUpTabBarVisibility() {
        if dataSource.serviceProvider.authentificationService.isLoggedId {
            tabBar.isHidden = false
        } else {
            tabBar.isHidden = true
        }
    }
}

extension MainScreenController: MainScreenViewInterface {
}
