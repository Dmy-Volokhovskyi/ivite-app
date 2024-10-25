final class SignInRouter: BaseRouter {
    func pushForgotPassword(serviceProvider: ServiceProvider) {
        let controller = ForgotPasswordBuilder(serviceProvider: serviceProvider).make()
//        controller.modalPresentationStyle = .fullScreen
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
