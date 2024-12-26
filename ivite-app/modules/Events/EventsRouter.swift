final class EventsRouter: BaseRouter {
    
    func switchToTab(index: Int) {
        guard let tabBarController = controller?.tabBarController else {
            print("Tab bar controller not found")
            return
        }
        tabBarController.selectedIndex = index
    }
    
    func showPreview(creatorFlowModel: CreatorFlowModel, serviceProvider: ServiceProvider) {
        
        let controller = PreviewInviteBuilder(serviceProvider: serviceProvider).make(previewMode: true, creatorFlowModel: creatorFlowModel)
        controller.modalPresentationStyle = .fullScreen
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
