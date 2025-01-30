import Foundation

protocol TemplateEditorDelegate: AnyObject {
    func didEndTemplateEdition(creatorFlowModel: CreatorFlowModel)
}

protocol TemplateEditorInteractorDelegate: AnyObject {
    func didLoadCanvasData()
}

final class TemplateEditorInteractor: BaseInteractor {
    weak var delegate: TemplateEditorInteractorDelegate?
    weak var editorDelegate: TemplateEditorDelegate?
    
    var creatorFlowModel: CreatorFlowModel
    var canvasURLString: String
    
    init(creatorFlowModel: CreatorFlowModel,
         urlString: String,
         serviceProvider: ServiceProvider) {
        self.creatorFlowModel = creatorFlowModel
        self.canvasURLString = urlString
        super.init(serviceProvider: serviceProvider)
    }
    /// Method to load canvas data from a Firebase Storage URL
    func loadCanvasData() async throws {
        // Convert string to URL
        guard let url = URL(string: canvasURLString) else {
            throw URLError(.badURL)
        }
        
        do {
            // Download data asynchronously
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode JSON data
            let decoder = JSONDecoder()
            let model = try decoder.decode(Canvas.self, from: data)
            
            // Update the creation flow model
            creatorFlowModel.originalCanvas = model
            creatorFlowModel.canvas = model.copy()
            delegate?.didLoadCanvasData()
        } catch {
            // Handle and propagate any errors
            print("Error downloading or parsing JSON: \(error)")
            throw error
        }
    }
}
