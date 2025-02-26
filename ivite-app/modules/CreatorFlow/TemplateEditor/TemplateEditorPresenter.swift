import UIKit

protocol TemplateEditorViewInterface: AnyObject {
    func loadCanvas()
    func updateTextLayer(_ layer: TextLayer)
    func updateImageLayer(_ layer: ImageLayer)
    func getImage() -> UIImage?
}

final class TemplateEditorPresenter: BasePresenter {
    private let interactor: TemplateEditorInteractor
    let router: TemplateEditorRouter
    weak var viewInterface: TemplateEditorController?
    
    init(router: TemplateEditorRouter, interactor: TemplateEditorInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension TemplateEditorPresenter: TemplateEditorEventHandler {
    func updateImageLayer(with image: UIImage, layerIndex: Int) {
        // Ensure the layerIndex is valid and retrieve the image layer
        guard let canvas = interactor.creatorFlowModel.canvas,
              layerIndex >= 0,
              layerIndex < canvas.content.count,
              case let .image(imageLayer) = canvas.content[layerIndex] else {
            return
        }
        
        // Update the `customImage` property of the image layer
        imageLayer.customImage = image
        
        // Replace the updated layer back into the canvas
        interactor.creatorFlowModel.canvas?.content[layerIndex] = .image(imageLayer)
        
        // Notify the view interface to update the layer
        viewInterface?.updateImageLayer(imageLayer)
    }
    
    func nextButtonTapped() {
        interactor.creatorFlowModel.image = viewInterface?.getImage()
        interactor.editorDelegate?.didEndTemplateEdition(creatorFlowModel: interactor.creatorFlowModel)
    }
    
    func didUpdatePositionAndSize(for id: String, with coordinates: Coordinates, and size: Size) {
        guard let index = interactor.creatorFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }
        
        // Check the layer type and update the coordinates and size accordingly
        switch interactor.creatorFlowModel.canvas?.content[index] {
        case .text(let textLayer):
            textLayer.textBoxCoordinates = TextBoxCoordinates(
                x: Double(coordinates.x),
                y: Double(coordinates.y),
                width: Double(size.width),
                height: Double(size.height)
            )
            interactor.creatorFlowModel.canvas?.content[index] = .text(textLayer)
            //            viewInterface?.updateTextLayer(textLayer)
            
        case .image(let imageLayer):
            imageLayer.coordinates = coordinates
            imageLayer.size = size
            interactor.creatorFlowModel.canvas?.content[index] = .image(imageLayer)
            //            viewInterface?.updateImageLayer(imageLayer)
        case .shape(let shapeLayer):
            shapeLayer.coordinates = coordinates
            shapeLayer.size = size
            interactor.creatorFlowModel.canvas?.content[index] = .shape(shapeLayer)
        case .none:
            break
        }
    }
    
    
    func didSelectLineHeight(for id: String, with height: CGFloat) {
        guard let layer = interactor.creatorFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = layer {
            textLayer.lineHeight = height
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelectLetterSpacing(for id: String, with spacing: CGFloat) {
        guard let layer = interactor.creatorFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = layer {
            textLayer.letterSpacing = spacing
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelectTextFormating(for id: String, with format: TextFormatting) {
        guard let index = interactor.creatorFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = interactor.creatorFlowModel.canvas?.content[index] {
            textLayer.textFormatting = format
            interactor.creatorFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        } else {
            
        }
    }
    
    func didSelectAlignment(for id: String, with alignment: TextAlignment) {
        guard let layer = interactor.creatorFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = layer {
            textLayer.textAlignment = alignment
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelecteTextColor(for id: String, with color: String) {
        print(color)
        guard let layer = interactor.creatorFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = layer {
            textLayer.textColor = color
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelectFontSize(for id: String, with size: Double) {
        guard let layer = interactor.creatorFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = layer {
            textLayer.fontSize = size
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelectNewFont(for id: String, with name: String) {
        guard let layer = interactor.creatorFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = layer {
            textLayer.font = name
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func resetFont(for id: String) {
        guard let originalLayer = interactor.creatorFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creatorFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = interactor.creatorFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.font = originalTextLayer.font
            interactor.creatorFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }
    
    func resetFontSize(for id: String) {
        guard let originalLayer = interactor.creatorFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creatorFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = interactor.creatorFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.fontSize = originalTextLayer.fontSize
            interactor.creatorFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }
    
    func resetTextColor(for id: String) {
        guard let originalLayer = interactor.creatorFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creatorFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = interactor.creatorFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.textColor = originalTextLayer.textColor
            interactor.creatorFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }
    
    func resetTextFormatingAndAllinement(for id: String) {
        guard let originalLayer = interactor.creatorFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creatorFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = interactor.creatorFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.textAlignment = originalTextLayer.textAlignment
            textLayer.textFormatting = originalTextLayer.textFormatting
            
            interactor.creatorFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }
    
    func resetLineHeight(for id: String) {
        guard let originalLayer = interactor.creatorFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creatorFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = interactor.creatorFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.lineHeight = originalTextLayer.lineHeight
            interactor.creatorFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }
    
    func resetLetterSpacing(for id: String) {
        guard let originalLayer = interactor.creatorFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creatorFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }
        
        if case let .text(textLayer) = interactor.creatorFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.letterSpacing = originalTextLayer.letterSpacing
            interactor.creatorFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }
    
    
    func viewDidLoad() {
        Task {
            do {
                try await interactor.loadCanvasData()
            } catch {
                print("Failed to load canvas data: \(error)")
                router.dismiss(completion: nil)
            }
        }
    }
    
}

extension TemplateEditorPresenter: TemplateEditorDataSource {
    func getLayerType(for id: String) -> LayerType? {
        guard let layer = interactor.creatorFlowModel.canvas?.content.first(where: { $0.id == id }) else { return nil }
        
        // Check if it's a text layer and extract the font size
        if case .text = layer {
            return .text
        } else if case .image = layer {
            return .image
        } else {
            // If the layer is not a TextLayer, return nil
            return nil
        }
    }
    
    var canvas: Canvas? { interactor.creatorFlowModel.originalCanvas }
    func getFontSize(for id: String) -> Double? {
        // Find the layer with the given id
        guard let layer = interactor.creatorFlowModel.canvas?.content.first(where: { $0.id == id }) else { return nil }
        
        // Check if it's a text layer and extract the font size
        if case let .text(textLayer) = layer {
            return textLayer.fontSize
        } else {
            // If the layer is not a TextLayer, return nil
            return nil
        }
    }
}

extension TemplateEditorPresenter: TemplateEditorInteractorDelegate {
    func didLoadCanvasData() {
        DispatchQueue.main.async {
            self.viewInterface?.loadCanvas()
        }
    }
}
