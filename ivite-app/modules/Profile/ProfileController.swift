import UIKit

protocol ProfileEventHandler: AnyObject {
}

protocol ProfileDataSource: AnyObject {
}

final class ProfileController: BaseViewController, UIScrollViewDelegate {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let eventHandler: ProfileEventHandler
    private let dataSource: ProfileDataSource
    private let layoutButton = UIButton(configuration: .secondary(title: "LOAD"))
    
    private var canvasData: CanvasResponse? // Holds the parsed Canvas JSON
    
    init(eventHandler: ProfileEventHandler, dataSource: ProfileDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let zoomButton = UIButton(type: .system)
    
    // Constraints to store
    private var contentViewWidthConstraint: NSLayoutConstraint!
    private var contentViewHeightConstraint: NSLayoutConstraint!
    
    override func setupView() {
        super.setupView()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        contentView.backgroundColor = .lightGray
        
        zoomButton.setTitle("Load Canvas", for: .normal)
        zoomButton.addTarget(self, action: #selector(zoomButtonTapped), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(zoomButton)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        scrollView.autoPinEdgesToSuperviewSafeArea()
        
        contentView.autoAlignAxis(toSuperviewAxis: .horizontal)
        contentView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        zoomButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        zoomButton.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    @objc func zoomButtonTapped() {
        loadCanvasData()
        guard let canvas = self.canvasData?.canvas else { return }

        // Calculate scaling factor to fit canvas into 90% of the screen size
        let screenSize = UIScreen.main.bounds.size
        let scaleFactor = min((screenSize.width * 0.9) / CGFloat(canvas.size.width),
                              (screenSize.height * 0.9) / CGFloat(canvas.size.height))
        
        let scaledWidth = CGFloat(canvas.size.width) * scaleFactor
        let scaledHeight = CGFloat(canvas.size.height) * scaleFactor
        
        // Ensure constraints are reset before applying new ones
        self.contentViewWidthConstraint?.isActive = false
        self.contentViewHeightConstraint?.isActive = false
        
        // Animate the content view to resize to the scaled size
        UIView.animate(withDuration: 0.3) {
            self.contentViewWidthConstraint = self.contentView.autoSetDimension(.width, toSize: scaledWidth)
            self.contentViewHeightConstraint = self.contentView.autoSetDimension(.height, toSize: scaledHeight)
            self.view.layoutIfNeeded()
        }
        
        // Set up layers for the canvas, with the scaling factor
        setupLayers(from: canvas, scaleFactor: scaleFactor)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    private func loadCanvasData() {
        if let url = Bundle.main.url(forResource: "canvasData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.canvasData = try decoder.decode(CanvasResponse.self, from: data)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
    }

    private func setupLayers(from canvas: Canvas, scaleFactor: CGFloat) {
        // Remove all existing subviews in case of relayout
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        for layer in canvas.content {
            switch layer.type {
            case "image":
                addImageLayer(layer, scale: scaleFactor)
            case "text":
                addTextLayer(layer, scale: scaleFactor)
            default:
                break
            }
        }
    }
    
    private func addImageLayer(_ layer: Layer, scale: CGFloat) {
        let size: CGSize
        let coordinates: Coordinates
        print(layer.croppedSize, layer.croppedCoordinates, "SIZE COOR, no scale")
        if layer.imageFile == "image3" {
            print(layer)
        }
        // Scale the size and coordinates
        if layer.editable, let croppedSize = layer.croppedSize, let croppedCoordinates = layer.croppedCoordinates {
            size = CGSize(width: CGFloat(croppedSize.width) * scale, height: CGFloat(croppedSize.height) * scale)
            coordinates = croppedCoordinates
            print(size, coordinates, "SIZE COOR, EDITABLE")
        } else {
            size = CGSize(width: CGFloat(layer.size.width) * scale, height: CGFloat(layer.size.height) * scale)
            coordinates = layer.coordinates
        }

        // Create and scale the image view
        if let imageName = layer.imageFile, let image = UIImage(named: imageName) {
            let imageView = UIImageView(image: image)
            imageView.isUserInteractionEnabled = layer.editable
            imageView.contentMode = .scaleAspectFit
            contentView.addSubview(imageView)

            // Apply scaled constraints for image size and position
            imageView.autoSetDimensions(to: size)
            imageView.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: CGFloat(coordinates.x) * scale)
            imageView.autoPinEdge(.top, to: .top, of: contentView, withOffset: CGFloat(coordinates.y) * scale)
        }
    }

    private func addTextLayer(_ layer: Layer, scale: CGFloat) {
        guard let textBoxCoordinates = layer.textBoxCoordinates else { return }
        let textSize = CGSize(width: layer.textBoxCoordinates?.width ?? 0, height: layer.textBoxCoordinates?.height ?? 0)
        print(layer.textValue, "Text value", scale)
        // Scale text size and position
        let scaledTextSize = CGSize(width: CGFloat(textSize.width) * scale, height: CGFloat(textSize.height) * scale)
        let scaledFontSize = (layer.fontSize != nil) ? CGFloat(Double(layer.fontSize!) ?? 131.4) * scale : 20.0 * scale
        print(layer.fontSize)
        
        let label = UILabel()
        label.text = layer.textValue
        label.font = UIFont.boldSystemFont(ofSize: scaledFontSize * 1.8)
        label.numberOfLines = 0
        label.textColor = .white
        contentView.addSubview(label)
        
//        label.autoSetDimensions(to: scaledTextSize)
        label.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: CGFloat(textBoxCoordinates.x) * scale)
        label.autoPinEdge(.top, to: .top, of: contentView, withOffset: CGFloat(textBoxCoordinates.y) * scale)
    }

}


struct Layer: Codable {
    let name: String
    let coordinates: Coordinates
    let size: Size
    let editable: Bool
    let type: String
    let imageFile: String?
    let textValue: String?
    let font: String?
    let fontSize: Double?
    let textBoxCoordinates: TextBoxCoordinates?
    let croppedSize: Size?
    let croppedCoordinates: Coordinates?
    
    enum CodingKeys: String, CodingKey {
        case name
        case coordinates
        case size
        case editable
        case type
        case imageFile = "image_file"
        case textValue = "text_value"
        case font
        case fontSize = "font_size"
        case textBoxCoordinates = "text_box_coordinates"
        case croppedSize = "cropped_size"
        case croppedCoordinates = "cropped_coordinates"
    }
}

struct Coordinates: Codable {
    let x: Int
    let y: Int
}

struct TextBoxCoordinates: Codable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}

struct Size: Codable {
    let width: Int
    let height: Int
}

struct Canvas: Codable {
    let size: Size
    let numberOfLayers: Int
    let content: [Layer]
    
    enum CodingKeys: String, CodingKey {
        case size
        case numberOfLayers = "number_of_layers"
        case content
    }
}

struct CanvasResponse: Codable {
    let canvas: Canvas
}
