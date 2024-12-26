final class ReviewRouter: BaseRouter {
    func showPreview(creatorFlowModel: CreatorFlowModel, serviceProvider: ServiceProvider) {
        
        let controller = PreviewInviteBuilder(serviceProvider: serviceProvider).make(previewMode: true, creatorFlowModel: creatorFlowModel)
        controller.modalPresentationStyle = .fullScreen
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
