import Foundation

final class TemplateEditorBuilder: BaseBuilder {
    func make(creatorFlowModel: CreatorFlowModel,
              urlString: String,
              templateEditorDelegate: TemplateEditorDelegate) -> TemplateEditorController {
        let router = TemplateEditorRouter()
        let interactor = TemplateEditorInteractor(creatorFlowModel: creatorFlowModel,
                                                  urlString: urlString,
                                                  serviceProvider: serviceProvider)
        let presenter = TemplateEditorPresenter(router: router, interactor: interactor)
        let controller = TemplateEditorController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.editorDelegate = templateEditorDelegate
        
        router.controller = controller

        return controller
    }
}
