final class ProfileRouter: BaseRouter {
    func showProfileDetails(currentUser: IVUser, serviceProvider: ServiceProvider) {
        let controller = ProfileDetailsBuilder(serviceProvider: serviceProvider)
            .make(currentUser: currentUser)
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
