final class ProfileRouter: BaseRouter {
    func showProfileDetails(serviceProvider: ServiceProvider) {
        let controller = ProfileDetailsBuilder(serviceProvider: serviceProvider)
            .make()
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
