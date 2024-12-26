import Foundation

final class PreviewInviteBuilder: BaseBuilder {
    func make(previewMode: Bool, creatorFlowModel: CreatorFlowModel) -> PreviewInviteController {
        let router = PreviewInviteRouter()
        let interactor = PreviewInviteInteractor(previewMode: previewMode, creatorFlowModel: creatorFlowModel, serviceProvider: serviceProvider)
        let presenter = PreviewInvitePresenter(router: router, interactor: interactor)
        let controller = PreviewInviteController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
