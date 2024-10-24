import UIKit

final class ForgotPasswordRouter: BaseRouter {
    
    func showCheckEmail(serviceProvider: ServiceProvider) {
        let controller = CheckEmailBuilder(serviceProvider: serviceProvider).make()
        let navigationController = UINavigationController(rootViewController: controller)
//        navigationController.isFullScreen = true
        self.controller?.present(navigationController, animated: true)
    }
}
