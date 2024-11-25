final class SignInRouter: BaseRouter {
    func pushForgotPassword(serviceProvider: ServiceProvider) {
        let controller = ForgotPasswordBuilder(serviceProvider: serviceProvider).make()
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
