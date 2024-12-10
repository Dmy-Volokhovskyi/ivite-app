final class SignInRouter: BaseRouter {
    func pushForgotPassword(serviceProvider: ServiceProvider) {
        let controller = ForgotPasswordBuilder(serviceProvider: serviceProvider).make()
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showCreateAccount(serviceProvider: ServiceProvider) {
        let controller = CreateAccountBuilder(serviceProvider: serviceProvider)
            .make()
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
