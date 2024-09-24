import Foundation

final class TemplateEditorBuilder: BaseBuilder {
    func make(templateEditorDelegate: TemplateEditorDelegate) -> TemplateEditorController {
        let router = TemplateEditorRouter()
        let interactor = TemplateEditorInteractor(serviceProvider: serviceProvider)
        let presenter = TemplateEditorPresenter(router: router, interactor: interactor)
        let controller = TemplateEditorController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.editorDelegate = templateEditorDelegate
        
        router.controller = controller

        return controller
    }
}
