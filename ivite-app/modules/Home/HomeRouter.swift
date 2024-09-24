import UIKit

final class HomeRouter: BaseRouter {
    func switchToCreatorFlow(serviceProvider: ServiceProvider) {
        let controller = ConfigurationWizardBuilder(serviceProvider: serviceProvider).make()
        let navigationController = UINavigationController(rootViewController: controller)
        changeRoot(to: navigationController)
       }
}
