import UIKit

protocol MainScreenEventHandler: AnyObject {
}

protocol MainScreenDataSource: AnyObject {
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
//          setupTabBar()
      }
    
//    internal override func setupTabBar() {
//        // Create the view controllers for each tab
//        let serviceProvider = ServiceProvider()
//        let homeController = HomeBuilder(serviceProvider: serviceProvider).make()
//        let eventController = EventsBuilder(serviceProvider: serviceProvider).make()
//        let contactsController = ContactBuilder(serviceProvider: serviceProvider).make()
//        let profileController = ProfileBuilder(serviceProvider: serviceProvider).make()
//
//        // Assign titles and icons for the tab bar items
//        homeController.tabBarItem = UITabBarItem(title: "Home", image: .home, tag: 0)
//        eventController.tabBarItem = UITabBarItem(title: "Events", image: .events, tag: 1)
//        contactsController.tabBarItem = UITabBarItem(title: "Contacts", image: .contacts, tag: 2)
//        profileController.tabBarItem = UITabBarItem(title: "Profile", image: .profile, tag: 2)
//        // Set the view controllers of the tab bar
//        self.viewControllers = [homeController, eventController, contactsController, profileController]
//    }
}

extension MainScreenController: MainScreenViewInterface {
}
