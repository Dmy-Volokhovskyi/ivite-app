import UIKit

final class HomeRouter: BaseRouter {
    func switchToCreatorFlow(urlString: String, serviceProvider: ServiceProvider) {
        
        let controller = ConfigurationWizardBuilder(serviceProvider: serviceProvider).make(urlString: urlString)
        controller.modalPresentationStyle = .fullScreen
        self.controller?.present(controller, animated: true)
    }
    
    func showSignIn(serviceProvider: ServiceProvider) {
        let controller = SignInBuilder(serviceProvider: serviceProvider)
            .make()
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
