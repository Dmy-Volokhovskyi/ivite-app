import Foundation

protocol TemplateEditorDelegate: AnyObject {
    func didEndTemplateEdition()
}

protocol TemplateEditorInteractorDelegate: AnyObject {
}

final class TemplateEditorInteractor: BaseInteractor {
    weak var delegate: TemplateEditorInteractorDelegate?
    weak var editorDelegate: TemplateEditorDelegate?
    
    var creationFlowModel = CreatorFlowModel()
    
    func loadCanvasData() throws {
        if let url = Bundle.main.url(forResource: "canvasData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let model = try decoder.decode(Canvas.self, from: data)
                creationFlowModel.originalCanvas = model
                creationFlowModel.canvas = model.copy()
            } catch {
                print("Error parsing JSON: \(error)")
                throw error
            }
        }
    }
}
