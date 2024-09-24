import Foundation
import UIKit

protocol TemplateEditorViewInterface: AnyObject {
    func loadCanvas()
    func updateTextLayer(_ layer: TextLayer)
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
    func didUpdatePositionAndSize(for id: String, with coordinates: Coordinates, and size: Size) {
        guard let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

        // Check the layer type and update the coordinates and size accordingly
        switch interactor.creationFlowModel.canvas?.content[index] {
        case .text(var textLayer):
            textLayer.textBoxCoordinates = TextBoxCoordinates(
                        x: Double(coordinates.x),
                        y: Double(coordinates.y),
                        width: Double(size.width),
                        height: Double(size.height)
                    )
            interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
//            viewInterface?.updateTextLayer(textLayer)
            
        case .image(var imageLayer):
            imageLayer.coordinates = coordinates
            imageLayer.size = size
            interactor.creationFlowModel.canvas?.content[index] = .image(imageLayer)
//            viewInterface?.updateImageLayer(imageLayer)
            
        case .none:
            break
        }
    }

    
    func didSelectLineHeight(for id: String, with height: CGFloat) {
        guard let layer = interactor.creationFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = layer {
            textLayer.lineHeight = height
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelectLetterSpacing(for id: String, with spacing: CGFloat) {
        guard let layer = interactor.creationFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = layer {
            textLayer.letterSpacing = spacing
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelectTextFormating(for id: String, with format: TextFormatting) {
        guard let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

           if case var .text(textLayer) = interactor.creationFlowModel.canvas?.content[index] {
               textLayer.textFormatting = format
               interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
               viewInterface?.updateTextLayer(textLayer)
           } else {
               
           }
    }
    
    func didSelectAlignment(for id: String, with alignment: TextAlignment) {
        guard let layer = interactor.creationFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = layer {
            textLayer.textAlignment = alignment as? TextAlignment
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelecteTextColor(for id: String, with color: String) {
        print(color)
        guard let layer = interactor.creationFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = layer {
            textLayer.textColor = color
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelectFontSize(for id: String, with size: Double) {
        guard let layer = interactor.creationFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = layer {
            textLayer.fontSize = size
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func didSelectNewFont(for id: String, with name: String) {
        guard let layer = interactor.creationFlowModel.canvas?.content.first(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = layer {
            textLayer.font = name
            viewInterface?.updateTextLayer(textLayer)
        } else {
            // Handle the case where the layer is not a TextLayer, if needed
            return
        }
    }
    
    func resetFont(for id: String) {
        guard let originalLayer = interactor.creationFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = interactor.creationFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.font = originalTextLayer.font
            interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }

    func resetFontSize(for id: String) {
        guard let originalLayer = interactor.creationFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = interactor.creationFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.fontSize = originalTextLayer.fontSize
            interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }

    func resetTextColor(for id: String) {
        guard let originalLayer = interactor.creationFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = interactor.creationFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.textColor = originalTextLayer.textColor
            interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }

    func resetTextFormating(for id: String) {
        guard let originalLayer = interactor.creationFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = interactor.creationFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.textFormatting = originalTextLayer.textFormatting
            interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }

    func resetAlignment(for id: String) {
        guard let originalLayer = interactor.creationFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = interactor.creationFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.textAlignment = originalTextLayer.textAlignment
            interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }

    func resetLineHeight(for id: String) {
        guard let originalLayer = interactor.creationFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = interactor.creationFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.lineHeight = originalTextLayer.lineHeight
            interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }

    func resetLetterSpacing(for id: String) {
        guard let originalLayer = interactor.creationFlowModel.originalCanvas?.content.first(where: { $0.id == id }),
              let index = interactor.creationFlowModel.canvas?.content.firstIndex(where: { $0.id == id }) else { return }

        if case var .text(textLayer) = interactor.creationFlowModel.canvas?.content[index],
           case let .text(originalTextLayer) = originalLayer {
            
            textLayer.letterSpacing = originalTextLayer.letterSpacing
            interactor.creationFlowModel.canvas?.content[index] = .text(textLayer)
            viewInterface?.updateTextLayer(textLayer)
        }
    }

    
    func viewDidLoad() {
        do {
            try interactor.loadCanvasData()
            viewInterface?.loadCanvas()
        } catch {
            router.dismiss(completion: nil)
        }
    }
    
}

extension TemplateEditorPresenter: TemplateEditorDataSource {
    func getLayerType(for id: String) -> LayerType? {
        guard let layer = interactor.creationFlowModel.canvas?.content.first(where: { $0.id == id }) else { return nil }
        
        // Check if it's a text layer and extract the font size
        if case let .text(textLayer) = layer {
            return .text
        } else if case let .text(textLayer) = layer {
            return .image
        }
        else {
            // If the layer is not a TextLayer, return nil
            return nil
        }
    }
    
    var canvas: Canvas? { interactor.creationFlowModel.originalCanvas }
    func getFontSize(for id: String) -> Double? {
        // Find the layer with the given id
        guard let layer = interactor.creationFlowModel.canvas?.content.first(where: { $0.id == id }) else { return nil }

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
}
