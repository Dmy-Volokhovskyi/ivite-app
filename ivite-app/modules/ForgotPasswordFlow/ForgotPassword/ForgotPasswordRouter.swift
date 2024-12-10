import UIKit

final class ForgotPasswordRouter: BaseRouter {
    func showCheckEmail(email: String, serviceProvider: ServiceProvider) {
        let controller = CheckEmailBuilder(serviceProvider: serviceProvider).make(email: email)
        let navigationController = UINavigationController(rootViewController: controller)
        self.controller?.present(navigationController, animated: true)
    }
}
