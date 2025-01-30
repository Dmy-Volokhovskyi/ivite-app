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
    
    func loadCanvasData() async throws {
        guard let url = URL(string: canvasURLString) else {
            throw URLError(.badURL)
        }
        
        do {
            // 1️⃣ Download and decode the canvas
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let model = try decoder.decode(Canvas.self, from: data)
            
            // Update the creation flow model
            creatorFlowModel.originalCanvas = model
            creatorFlowModel.canvas = model.copy()
            
            // 2️⃣ Extract and clean font names
            var fontNames = Set<String>()
            
            for layer in model.content {
                switch layer {
                case .text(let textLayer):
                    if let font = textLayer.font {
                        let cleanedFontName = serviceProvider.fontManager.cleanFontName(font)
                        fontNames.insert(cleanedFontName)
                    }
                case .image, .shape:
                    break
                }
            }
            
            print("🆕 Cleaned font names:", fontNames)
            
            // 3️⃣ Download & Register Fonts
            do {
                let fontMapping = try await serviceProvider.fontManager.fetchFontsIfNeeded(fontNames: Array(fontNames))
                print("✅ Fonts loaded successfully: \(fontMapping)")
            } catch {
                print("⚠️ Font loading failed:", error.localizedDescription)
            }
            
            // 4️⃣ Notify that everything is ready
            delegate?.didLoadCanvasData()
        } catch {
            print("❌ Error downloading or parsing JSON:", error.localizedDescription)
            throw error
        }
    }
}
