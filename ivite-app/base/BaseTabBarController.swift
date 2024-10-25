//
//  BaseTabBarController.swift
//  ivite-app
//
//  Created by GoApps Developer on 02/09/2024.
//

import UIKit

class BaseTabBarController: UITabBarController {

    // Custom initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBar()
//        addViewControllers()
//        configureTabBarItems()
    }
    
    // Required initializer for using with storyboards or nibs
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Overriding loadView to perform initial setup
    override func loadView() {
        super.loadView()
        
        // Setup the tab bar controller
        setupTabBar()
        
        // Add view controllers to the tab bar
//        addViewControllers()
        
        // Configure tab bar items (e.g., icons, titles)
//        configureTabBarItems()
    }
    
    // Method to setup the tab bar appearance
    func setupTabBar() {
        // Create the view controllers for each tab


        // Assign titles and icons for the tab bar items
    
        // Set the view controllers of the tab bar

//        tabBar.tintColor = .white
//        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.2)
//        tabBar.barStyle = .default
    }

    // Method to add child view controllers to the tab bar
    func addViewControllers(controllers: [UIViewController]) {
 
        
        setViewControllers(controllers, animated: false)
    }
    
    // Method to configure the tab bar items for each view controller
//    func configureTabBarItems() {
//        // Override this method to customize tab bar items
//        // Example:
//        
//        viewControllers?[0].tabBarItem = UITabBarItem(title: "Home", image: .home, selectedImage: .homeActive)
//        viewControllers?[1].tabBarItem = UITabBarItem(title: "Events", image: .events, selectedImage: .eventsActive)
//        viewControllers?[2].tabBarItem = UITabBarItem(title: "Contacts", image: .contacts, selectedImage: .contactsActive)
//        viewControllers?[3].tabBarItem = UITabBarItem(title: "Profile", image: .profile, selectedImage: .profileActive)
//    }
}
