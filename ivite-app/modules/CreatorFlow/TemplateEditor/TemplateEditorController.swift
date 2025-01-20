import UIKit
// TODOS
// TODO: - Place View in center
// TODO: - Add cancel Selction gesture recognizer
// TODO: - add Text Edit
// TODO: - add spacing and lineheight
// TODO: - remove the Reset from model
// TODO: - add default highlight for editable

protocol TemplateEditorEventHandler: AnyObject {
    func viewDidLoad()
    func didSelectNewFont(for id: String, with name: String)
    func didSelectFontSize(for id: String, with size: Double)
    func didSelecteTextColor(for id: String, with color: String)
    func didSelectTextFormating(for id: String, with format: TextFormatting)
    func didSelectAlignment(for id: String, with alignment: TextAlignment)
    func didSelectLineHeight(for id: String, with height: CGFloat)
    func didSelectLetterSpacing(for id: String, with spacing: CGFloat)
    
    func resetFont(for id: String)
    func resetFontSize(for id: String)
    func resetTextColor(for id: String)
    func resetTextFormatingAndAllinement(for id: String)
    func resetLineHeight(for id: String)
    func resetLetterSpacing(for id: String)
    
    func didUpdatePositionAndSize(for id: String, with coordinates: Coordinates, and size: Size)
    func updateImageLayer(with image: UIImage, layerIndex: Int)
    func nextButtonTapped()
}

protocol TemplateEditorDataSource: AnyObject {
    var canvas: Canvas? { get }
    
    func getFontSize(for id: String) -> Double?
    func getLayerType(for id: String) -> LayerType?
}

final class TemplateEditorController: BaseViewController {
    private let eventHandler: TemplateEditorEventHandler
    private let dataSource: TemplateEditorDataSource
    
    private var activeResizableView: RKUserResizableView? {
        didSet {
            activeResizableView?.showEditingHandles()
            oldValue?.hideEditingHandles()
            oldValue?.contentView?.resignFirstResponder()
            //            activeResizableView?.contentView?.resignFirstResponder()
            toggleControlls(for: activeResizableView)
        }
    }
    
    private var scaleFactor: CGFloat?
    
    private let bottomMenu = TextEditMenuView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let fontSelectionView = FontSelectionView(seletedFont: nil)
    private let fontSizePicker = FontSizePickerView()
    private let colorPickerView = ColorPickerView()
    private let textFormattingPicker = TextFormatPickerView()
    private let spacingPickerView = SpacingPickerView()
    // Constraints to store
    private var contentViewWidthConstraint: NSLayoutConstraint!
    private var contentViewHeightConstraint: NSLayoutConstraint!
    
    private let bottomBarView = UIView()
    private let bottomDividerView = DividerView()
    private let nextButton = UIButton(configuration: .primary(title: "Next",
                                                              insets: NSDirectionalEdgeInsets(top: 13, leading: 24, bottom: 13, trailing: 24)))
    
    init(eventHandler: TemplateEditorEventHandler, dataSource: TemplateEditorDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.addSubview(bottomBarView)
        
        bottomBarView.addSubview(bottomDividerView)
        bottomBarView.addSubview(nextButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(bottomMenu)
        view.addSubview(fontSelectionView)
        view.addSubview(fontSizePicker)
        view.addSubview(colorPickerView)
        view.addSubview(textFormattingPicker)
        view.addSubview(spacingPickerView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        // Set the scrollView to pin to the edges of the view with insets
        scrollView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0), excludingEdge: .bottom)
        
        // Set the contentView to pin to the scrollView edges with insets (16 on left/right)
        contentView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        contentView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        // Pin top and bottom as usual to allow vertical scrolling
        contentView.autoPinEdge(toSuperviewEdge: .top)
        contentView.autoPinEdge(toSuperviewEdge: .bottom)
        
        // Ensure the contentView matches the scrollView's width with the insets
        contentView.autoMatch(.width, to: .width, of: scrollView, withOffset: -32) // -32 accounts for 16px insets on each side
        
        // Optional: Define a minimum height for the contentView to ensure scrolling is possible
        //        contentView.autoSetDimension(.height, toSize: 1000, relation: .greaterThanOrEqual)
        
        // Constrain other subviews as needed
        bottomBarView.autoPinEdge(.top, to: .bottom, of: scrollView, withOffset: 16)
        bottomBarView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        bottomMenu.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .top)
        fontSelectionView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        fontSelectionView.autoSetDimension(.height, toSize: view.frame.height / 4)
        
        fontSizePicker.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        fontSizePicker.autoSetDimension(.height, toSize: 200)
        
        colorPickerView.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .top)
        colorPickerView.autoSetDimension(.height, toSize: 200)
        
        textFormattingPicker.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .top)
        textFormattingPicker.autoSetDimension(.height, toSize: 200)
        
        spacingPickerView.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .top)
        spacingPickerView.autoSetDimension(.height, toSize: 200)
        
        setUpBottomViewConstraints()
    }
    
    
    override func setupView() {
        super.setupView()
        
        bottomBarView.backgroundColor = .white
        view.backgroundColor = .dark10
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        bottomMenu.delegate = self
        
        contentView.backgroundColor = .lightGray
        
        fontSelectionView.isHidden = true
        fontSelectionView.delegate = self
        
        fontSizePicker.delegate = self
        fontSizePicker.isHidden = true
        
        colorPickerView.delegate = self
        colorPickerView.isHidden = true
        
        textFormattingPicker.delegate = self
        textFormattingPicker.isHidden = true
        
        spacingPickerView.delegate = self
        spacingPickerView.isHidden = true
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelSelection))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.delaysTouchesBegan = false
        contentView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler.viewDidLoad()
        
        bottomMenu.isHidden = true
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove keyboard notifications
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpBottomViewConstraints() {
        bottomDividerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        nextButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        nextButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        nextButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        nextButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        
        nextButton.setContentHuggingPriority(.init(999), for: .vertical)
        nextButton.setContentCompressionResistancePriority(.init(999), for: .vertical)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        eventHandler.nextButtonTapped()
    }
    
    @objc func cancelSelection(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: contentView)
        
        var tappedInsideAnyView = false
        
        // Iterate over all subviews to check if the tap is inside any RKUserResizableView
        for subview in contentView.subviews {
            if let resizableView = subview as? RKUserResizableView {
                if resizableView.frame.contains(location) {
                    tappedInsideAnyView = true
                    activeResizableView = resizableView
                    activeResizableView?.showEditingHandles()
                    break
                }
            }
        }
        print(tappedInsideAnyView, "xxxxx")
        // If the tap is outside all RKUserResizableViews, hide editing handles and clear activeResizableView
        if !tappedInsideAnyView {
            activeResizableView?.hideEditingHandles()
            activeResizableView = nil
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        // Adjust scrollView's content inset to accommodate the keyboard
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // Scroll to make the active text view fully visible
        if let textView = activeResizableView?.contentView as? UITextView, textView.isFirstResponder {
            let textViewFrameInContentView = textView.convert(textView.bounds, to: scrollView)
            scrollView.scrollRectToVisible(textViewFrameInContentView, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Reset scrollView's content inset when the keyboard is dismissed
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    private func setupLayers(from canvas: Canvas, scaleFactor: CGFloat) {
        // Remove all existing subviews in case of relayout
        contentView.subviews.forEach { $0.removeFromSuperview() }
        self.scaleFactor = scaleFactor
        
        for layer in canvas.content {
            switch layer {
            case .image(let imageLayer):
                addImageLayer(imageLayer, scale: scaleFactor)
            case .text(let textLayer):
                addTextLayer(textLayer, scale: scaleFactor)
            case .shape(let shapeLayer):
                addShapeLayer(shapeLayer, scale: scaleFactor) // NEW
            }
        }
    }
    
    private func addShapeLayer(_ layer: ShapeLayer, scale: CGFloat) {
        // Scale coordinates and size
        let xPos = CGFloat(layer.coordinates.x) * scale
        let yPos = CGFloat(layer.coordinates.y) * scale
        let width = CGFloat(layer.size.width) * scale
        let height = CGFloat(layer.size.height) * scale
        
        // Create a UIView to represent the shape layer
        let shapeView = UIView(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
        shapeView.isUserInteractionEnabled = layer.editable
        // Apply background color if present
        if let hexColor = layer.backgroundColor, let uiColor = UIColor(hex: hexColor) {
            print(hexColor)
            shapeView.backgroundColor = uiColor
        } else {
            shapeView.backgroundColor = .clear
        }
        
        // Apply corner radius if present
        if let cornerRadius = layer.cornerRadius {
            shapeView.layer.cornerRadius = CGFloat(cornerRadius) * scale
            shapeView.clipsToBounds = true
        }
        
        // If editable, wrap it in a resizable view
        if layer.editable {
            let resizableView = RKUserResizableView(frame: shapeView.frame)
            resizableView.id = layer.id
            resizableView.delegate = self
            resizableView.contentView = shapeView
            contentView.addSubview(resizableView)
        } else {
            // Not editable, just add directly
            contentView.addSubview(shapeView)
        }
    }
    
    private func addImageLayer(_ layer: ImageLayer, scale: CGFloat) {
        let size: CGSize
        let coordinates: Coordinates
        
        // Scale the size and coordinates
        if layer.editable,
           let croppedSize = layer.croppedSize,
           let croppedCoordinates = layer.croppedCoordinates {
            size = CGSize(width: CGFloat(croppedSize.width) * scale, height: CGFloat(croppedSize.height) * scale)
            coordinates = croppedCoordinates
        } else {
            size = CGSize(width: CGFloat(layer.size.width) * scale, height: CGFloat(layer.size.height) * scale)
            coordinates = layer.coordinates
        }
        
        // Determine which image to use
        let image: UIImage?
        if let customImage = layer.customImage {
            image = customImage
        } else if let imageName = layer.imageFile {
            image = UIImage(named: imageName)
        } else {
            image = nil
        }
        
        // Proceed only if an image is available
        guard let displayImage = image else { return }
        
        let imageView = UIImageView(image: displayImage)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = layer.editable
        
        // Set background color if available
        if let hexColor = layer.backgroundColor, let uiColor = UIColor(hex: hexColor) {
            imageView.backgroundColor = uiColor
        } else {
            imageView.backgroundColor = .clear
        }
        
        // Handle editable layers
        if layer.editable {
            // Create frame for the resizable view using coordinates and size
            let imageFrame = CGRect(x: CGFloat(coordinates.x) * scale,
                                    y: CGFloat(coordinates.y) * scale,
                                    width: size.width,
                                    height: size.height)
            
            let resizableImageView = RKUserResizableView(frame: imageFrame)
            imageView.contentMode = .scaleToFill
            resizableImageView.id = layer.id
            resizableImageView.contentView = imageView
            resizableImageView.delegate = self
            
            // Add a button for changing the image
            let button = UIButton(type: .system)
            button.setTitle("Pick Image", for: .normal)
            button.tintColor = .white
            button.backgroundColor = .black.withAlphaComponent(0.5)
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(changeImageButtonTapped(_:)), for: .touchUpInside)
            button.tag = dataSource.canvas?.content.firstIndex(where: { $0.id == layer.id }) ?? 0
            
            resizableImageView.addSubview(imageView)
            resizableImageView.addSubview(button)
            button.autoCenterInSuperview()
            contentView.addSubview(resizableImageView)
        } else {
            // Handle non-editable layers
            let imageFrame = CGRect(x: CGFloat(coordinates.x) * scale,
                                    y: CGFloat(coordinates.y) * scale,
                                    width: size.width,
                                    height: size.height)
            imageView.frame = imageFrame
            contentView.addSubview(imageView)
        }
    }
    
    private func addTextLayer(_ layer: TextLayer, scale: CGFloat) {
        guard let textBoxCoordinates = layer.textBoxCoordinates else { return }
        
        let scaledTextBoxWidth = CGFloat(textBoxCoordinates.width) * scale
        let scaledTextBoxHeight = CGFloat(textBoxCoordinates.height) * scale
        let label = createTextView(for: layer, scale: scale)
        
        // Calculate rotation transform
        let rotationAngle = layer.rotation ?? 0 // Default to 0 if no rotation is provided
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        // Check if the layer is editable and apply resizable logic
        if layer.editable {
            let resizableTextView = RKUserResizableView(frame: CGRect(x: CGFloat(textBoxCoordinates.x) * scale,
                                                                      y: CGFloat(textBoxCoordinates.y) * scale,
                                                                      width: scaledTextBoxWidth,
                                                                      height: scaledTextBoxHeight))
            resizableTextView.contentView = label
            resizableTextView.id = layer.id
            resizableTextView.delegate = self
            resizableTextView.transform = rotationTransform // Apply rotation to the resizable view
            resizableTextView.currentRotation = rotationAngle // Store the rotation
            contentView.addSubview(resizableTextView)
        } else {
            label.frame = CGRect(x: CGFloat(textBoxCoordinates.x) * scale,
                                 y: CGFloat(textBoxCoordinates.y) * scale,
                                 width: scaledTextBoxWidth,
                                 height: scaledTextBoxHeight)
            label.transform = rotationTransform // Apply rotation directly to the label
            contentView.addSubview(label)
        }
    }

    
    private func updateTextLayer(_ resizableView: RKUserResizableView, with layer: TextLayer, scale: CGFloat) {
        guard let textBoxCoordinates = layer.textBoxCoordinates, let label = resizableView.contentView as? UITextView else { return }
        
        // Update frame
        let scaledTextBoxWidth = CGFloat(textBoxCoordinates.width) * scale
        let scaledTextBoxHeight = CGFloat(textBoxCoordinates.height) * scale
        resizableView.frame = CGRect(x: CGFloat(textBoxCoordinates.x) * scale,
                                     y: CGFloat(textBoxCoordinates.y) * scale,
                                     width: scaledTextBoxWidth,
                                     height: scaledTextBoxHeight)
        
        // Re-apply attributes to the text
        applyTextAttributes(to: label, layer: layer, scale: scale)
    }
    
    // Helper method to create the text view with initial configuration
    private func createTextView(for layer: TextLayer, scale: CGFloat) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = .zero // Ensure no default padding
        textView.textContainer.lineFragmentPadding = 0 // Ensure no extra padding around text
        
        // Apply text and attributes
        textView.text = layer.textValue
        applyTextAttributes(to: textView, layer: layer, scale: scale)
        
        return textView
    }
    
    private func applyTextAttributes(to textView: UITextView, layer: TextLayer, scale: CGFloat) {
        let scaledFontSize = CGFloat(layer.fontSize ?? 131.4) * scale
        let attributedString = NSMutableAttributedString(string: textView.text ?? "")
        
        // Configure the font
        let font: UIFont
        if let fontName = layer.font, let customFont = UIFont(name: fontName, size: scaledFontSize) {
            font = customFont
            print( font.lineHeight, "Font Lineheight")
        } else {
            font = UIFont.systemFont(ofSize: scaledFontSize)
        }
        // Apply text color
        if let hexColor = layer.textColor, let textColor = UIColor(hex: hexColor) {
            attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attributedString.length))
        } else {
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length)) // Default to white
        }
        
        // Apply text formatting (all caps, lowercase, capitalized)
        let formattedText = formatText(textView.text ?? "", basedOn: layer.textFormatting)
        attributedString.mutableString.setString(formattedText)
        
        // Calculate line height and baseline offset
        if let lineHeight = layer.lineHeight {
            let scaledLineHeight = max(CGFloat(lineHeight) * scale, font.lineHeight) // Ensure line height is valid
            
            // Configure paragraph style
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = scaledLineHeight
            paragraphStyle.maximumLineHeight = scaledLineHeight
            paragraphStyle.alignment = textAlignment(from: layer.textAlignment)
            
            // Calculate baseline offset for vertical centering
            let baselineOffset = (scaledLineHeight - font.lineHeight) / 2.0
            
            // Apply attributes
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: NSRange(location: 0, length: attributedString.length))
        } else {
            // Fallback to font-only styling
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        }
        
        // Apply letter spacing
        if let letterSpacing = layer.letterSpacing {
            attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length))
        }
        
        // Ensure text container settings in UITextView do not interfere with rendering
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        // Assign attributed string to the label
        textView.attributedText = attributedString
    }
    
    // Helper method to handle text alignment
    private func textAlignment(from alignment: TextAlignment?) -> NSTextAlignment {
        switch alignment {
        case .left:
            return .left
        case .right:
            return .right
        case .center:
            return .center
        case .justified:
            return .justified
        case .none, .some:
            return .left
        }
    }
    
    // Helper method to apply text formatting
    private func formatText(_ text: String, basedOn formatting: TextFormatting?) -> String {
        switch formatting {
        case .allCaps:
            return text.uppercased()
        case .allLowercase:
            return text.lowercased()
        case .capitalized:
            return text.capitalized
        case .none, .some(.none):
            return text
        }
    }
    
    @objc private func changeImageButtonTapped(_ sender: UIButton) {
        let layerId = sender.tag
        // Implement the logic to change the image for the layer with the given ID
        print("Change image button tapped for layer ID: \(layerId)")
        
        // For example, present an image picker to select a new image
        presentImagePicker(forLayerId: layerId)
    }
    
    private func presentImagePicker(forLayerId layerId: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.view.tag = layerId // Tag the image picker with the layer ID
        present(imagePicker, animated: true)
    }
}

extension TemplateEditorController: TemplateEditorViewInterface {
    func updateImageLayer(_ layer: ImageLayer) {
        // Find the matching resizable view for the image layer
        guard let resizableView = contentView.subviews.compactMap({ $0 as? RKUserResizableView }).first(where: { $0.id == layer.id }) else {
            print("No matching resizable view found for ImageLayer with ID: \(layer.id)")
            return
        }
        
        // Ensure the resizable view's contentView is a UIImageView
        guard let imageView = resizableView.contentView as? UIImageView else {
            print("ContentView is not a UIImageView")
            return
        }
        
        // Update the image in the UIImageView
        if let customImage = layer.customImage {
            imageView.image = customImage
        } else if let imageName = layer.imageFile, let image = UIImage(named: imageName) {
            imageView.image = image
        } else {
            print("No image available for ImageLayer with ID: \(layer.id)")
            return
        }
        
        // Update additional properties like background color
        if let hexColor = layer.backgroundColor, let uiColor = UIColor(hex: hexColor) {
            imageView.backgroundColor = uiColor
        } else {
            imageView.backgroundColor = .clear
        }
        
        // Update the frame of the resizable view if coordinates or size have changed
        let newFrame = CGRect(
            x: CGFloat(layer.coordinates.x) * self.scaleFactor!,
            y: CGFloat(layer.coordinates.y) * self.scaleFactor!,
            width: CGFloat(layer.size.width) * self.scaleFactor!,
            height: CGFloat(layer.size.height) * self.scaleFactor!
        )
        resizableView.frame = newFrame
    }
    
    func updateTextLayer(_ layer: TextLayer) {
        guard let resizableView = contentView.subviews.compactMap({ $0 as? RKUserResizableView }).first(where: { $0.id == layer.id }) else {
            print("No matching resizable view found")
            return
        }
        
        // Update the resizable view with the new layer's properties
        updateTextLayer(resizableView, with: layer, scale: self.scaleFactor!)
    }
    
    func loadCanvas() {
        guard let canvas = dataSource.canvas else { return }
        
        // Calculate scaling factor to fit canvas into 90% of the screen size
        let screenSize = UIScreen.main.bounds.size
        
        let scaleFactor = min((screenSize.width  - 32) / CGFloat(canvas.size.width),
                              (screenSize.height - 64) / CGFloat(canvas.size.height))
        
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
    
    private func toggleControlls(for resizableView: RKUserResizableView?) {
        guard let resizableView,
              let id = resizableView.id,
              let type = dataSource.getLayerType(for: id)
        else {
            bottomMenu.isHidden = true
            return
        }
        
        switch type {
        case .text:
            // Show text-edit menu
            bottomMenu.isHidden = false
            
        case .image, .shape:
            // For images and shapes, hide the text-edit menu
            bottomMenu.isHidden = true
        }
    }
    
}

extension TemplateEditorController: UIScrollViewDelegate {
    
}

extension TemplateEditorController: TextEditMenuDelegate {
    func textEditMenu(_ menu: TextEditMenuView, didSelectItem item: TextEditMenuItem) {
        switch item {
        case .editText:
            if let textView = activeResizableView?.contentView as? UITextView {
                textView.becomeFirstResponder()
                
                // Calculate the frame of the textView relative to the scrollView's content
                let textViewFrameInContentView = textView.convert(textView.bounds, to: scrollView)
                
                // Scroll to make the textView fully visible
                scrollView.scrollRectToVisible(textViewFrameInContentView, animated: true)
                
                print("Selected menu item: \(item.title)")
            }
        case .font:
            fontSelectionView.isHidden.toggle()
        case .size:
            guard let id = activeResizableView?.id,
                  let fontSize = dataSource.getFontSize(for: id) else { return }
            fontSizePicker.setCurrentFontSize(fontSize)
            
            fontSizePicker.isHidden.toggle()
            print("Selected menu item: \(item.title)")
        case .color:
            colorPickerView.isHidden.toggle()
            print("Selected menu item: \(item.title)")
        case .format:
            textFormattingPicker.isHidden.toggle()
            print("Selected menu item: \(item.title)")
        case .spacing:
            spacingPickerView.isHidden.toggle()
            print("Selected menu item: \(item.title)")
        }
        
        // Handle item selection logic here
    }
}

extension TemplateEditorController: RKUserResizableViewDelegate{
    func userResizableViewDidBeginEditing(_ userResizableView: RKUserResizableView) {
        activeResizableView?.hideEditingHandles()
        
        // Set the new active view and show its handles
        activeResizableView = userResizableView
        userResizableView.showEditingHandles()
    }
    
    func userResizableViewDidEndEditing(_ userResizableView: RKUserResizableView) {
        guard let id = userResizableView.id, let scaleFactor = scaleFactor else { return }
        
        // Extract the actual (unscaled) coordinates and size by dividing by the scaleFactor
        let actualCoordinates = Coordinates(
            x: userResizableView.frame.origin.x / scaleFactor,
            y: userResizableView.frame.origin.y / scaleFactor
        )
        let actualSize = Size(
            width: userResizableView.frame.size.width / scaleFactor,
            height: userResizableView.frame.size.height / scaleFactor
        )
        
        // Notify the presenter of the changes
        eventHandler.didUpdatePositionAndSize(for: id, with: actualCoordinates, and: actualSize)
        
        print("End editing", id, "new position:", actualCoordinates, "new size:", actualSize)
    }
    
}

extension TemplateEditorController: FontSelectionDelegate {
    func fontSelectionViewDidSelectFont(_fontSelectionView: FontSelectionView, fontName: String) {
        print("Selected Font: \(fontName)")
        guard let id = activeResizableView?.id else { return }
        eventHandler.didSelectNewFont(for: id, with: fontName)
        fontSelectionView.isHidden.toggle()
    }
    
    func fontSelectionViewDidResetSelection(_fontSelectionView: FontSelectionView) {
        guard let id = activeResizableView?.id else { return }
        eventHandler.resetFont(for: id)
        fontSelectionView.isHidden.toggle()
    }
}

extension TemplateEditorController: FontSizePickerDelegate {
    func fontSizePickerDidSelectFontSize(_ pickerView: FontSizePickerView, fontSize: CGFloat) {
        print("Selected font size: \(fontSize)")
        // Update the currently active text layer with the new font size
        if let activeLayerID = activeResizableView?.id {
            eventHandler.didSelectFontSize(for: activeLayerID, with: fontSize)
        }
    }
    
    func fontSizePickerDidReset(_ pickerView: FontSizePickerView) {
        guard let id = activeResizableView?.id else { return }
        eventHandler.resetFontSize(for: id)
        fontSizePicker.isHidden.toggle()
        print("Font size reset to default")
    }
}

extension TemplateEditorController: ColorPickerDelegate {
    func colorPickerDidSelectColor(_ pickerView: ColorPickerView, color: String) {
        print("Selected color: \(color)")
        // Update the currently active text layer with the new color
        if let activeLayerID = activeResizableView?.id {
            eventHandler.didSelecteTextColor(for: activeLayerID, with: color)
        }
    }
    
    func colorPickerDidReset(_ pickerView: ColorPickerView) {
        guard let id = activeResizableView?.id else { return }
        eventHandler.resetTextColor(for: id)
        colorPickerView.isHidden.toggle()
        print("Color reset to default")
        // Handle resetting the color, maybe set the default color on the active layer
    }
}

extension TemplateEditorController: TextFormatPickerDelegate {
    func textFormatPickerDidSelectFormat(_ pickerView: TextFormatPickerView, format: TextFormatting) {
        // Handle text format change
        print("Selected format: \(format)")
        guard let activeLayerID = activeResizableView?.id else { return }
        eventHandler.didSelectTextFormating(for: activeLayerID, with: format)
    }
    
    func textFormatPickerDidSelectAlignment(_ pickerView: TextFormatPickerView, alignment: TextAlignment) {
        // Handle text alignment change
        print("Selected alignment: \(alignment)")
        guard let activeLayerID = activeResizableView?.id else { return }
        eventHandler.didSelectAlignment(for: activeLayerID , with: alignment)
    }
    
    func textFormatPickerDidReset(_ pickerView: TextFormatPickerView) {
        // Handle reset action
        guard let id = activeResizableView?.id else { return }
        eventHandler.resetTextFormatingAndAllinement(for: id)
        textFormattingPicker.isHidden.toggle()
        print("Text format and alignment reset")
    }
}

extension TemplateEditorController: SpacingPickerDelegate {
    func spacingPickerDidUpdateLetterSpacing(_ pickerView: SpacingPickerView, letterSpacing: CGFloat) {
        print("Updated letter spacing: \(letterSpacing)")
        guard let activeLayerID = activeResizableView?.id else { return }
        eventHandler.didSelectLetterSpacing(for: activeLayerID , with: letterSpacing)
        // Handle updating text layer with new letter spacing
    }
    
    func spacingPickerDidUpdateLineHeight(_ pickerView: SpacingPickerView, lineHeight: CGFloat) {
        print("Updated line height: \(lineHeight)")
        // Handle updating text layer with new line height
        guard let activeLayerID = activeResizableView?.id else { return }
        eventHandler.didSelectLineHeight(for: activeLayerID , with: lineHeight)
    }
    
    func spacingPickerDidReset(_ pickerView: SpacingPickerView) {
        print("Spacing reset to defaults")
        guard let id = activeResizableView?.id else { return }
        eventHandler.resetLetterSpacing(for: id)
        eventHandler.resetLineHeight(for: id)
        spacingPickerView.isHidden.toggle()
        // Handle reset logic
    }
}

extension TemplateEditorController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        
        let layerId = picker.view.tag
        eventHandler.updateImageLayer(with: selectedImage, layerIndex: layerId)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
