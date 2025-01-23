import Foundation

final class TemplateEditorBuilder: BaseBuilder {
    func make(templateEditorDelegate: TemplateEditorDelegate, urlString: String) -> TemplateEditorController {
        let router = TemplateEditorRouter()
        let interactor = TemplateEditorInteractor(urlString: urlString, serviceProvider: serviceProvider)
        let presenter = TemplateEditorPresenter(router: router, interactor: interactor)
        let controller = TemplateEditorController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        interactor.editorDelegate = templateEditorDelegate
        
        router.controller = controller

        return controller
    }
}
