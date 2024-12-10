final class CreateAccountRouter: BaseRouter {
    func showSignIn(serviceProvider: ServiceProvider) {
        let controller = SignInBuilder(serviceProvider: serviceProvider)
            .make()
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
