import UIKit

final class HomeRouter: BaseRouter {
    func switchToCreatorFlow(serviceProvider: ServiceProvider) {
        
        let controller = ConfigurationWizardBuilder(serviceProvider: serviceProvider).make()
        controller.modalPresentationStyle = .fullScreen
        self.controller?.present(controller, animated: true)
    }
    
    func showSignIn(signInDelegate: SignInDelegate, serviceProvider: ServiceProvider) {
        let controller = SignInBuilder(serviceProvider: serviceProvider)
            .make(signInDelegate: signInDelegate)
        //        controller.modalPresentationStyle = .fullScreen
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
