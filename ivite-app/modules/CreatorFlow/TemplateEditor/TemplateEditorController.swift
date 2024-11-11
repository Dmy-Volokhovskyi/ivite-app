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
    func resetTextFormating(for id: String)
    func resetAlignment(for id: String)
    func resetLineHeight(for id: String)
    func resetLetterSpacing(for id: String)
    
    func didUpdatePositionAndSize(for id: String, with coordinates: Coordinates, and size: Size)
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
        scrollView.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .bottom)

        // Set the contentView to pin to the scrollView edges with insets (16 on left/right)
        contentView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        contentView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        // Pin top and bottom as usual to allow vertical scrolling
        contentView.autoPinEdge(toSuperviewEdge: .top)
        contentView.autoPinEdge(toSuperviewEdge: .bottom)
        
        // Ensure the contentView matches the scrollView's width with the insets
        contentView.autoMatch(.width, to: .width, of: scrollView, withOffset: -32) // -32 accounts for 16px insets on each side

        // Optional: Define a minimum height for the contentView to ensure scrolling is possible
        contentView.autoSetDimension(.height, toSize: 1000, relation: .greaterThanOrEqual)

        // Constrain other subviews as needed
        bottomBarView.autoPinEdge(.top, to: .bottom, of: scrollView, withOffset: 16)
        bottomBarView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        bottomMenu.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .top)
        fontSelectionView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        fontSelectionView.autoSetDimension(.height, toSize: 200)
        
        fontSizePicker.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        fontSizePicker.autoSetDimension(.height, toSize: 200)
        
        colorPickerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        colorPickerView.autoSetDimension(.height, toSize: 200)
        
        textFormattingPicker.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        textFormattingPicker.autoSetDimension(.height, toSize: 200)
        
        spacingPickerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
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
            }
        }
    }
    
    private func addImageLayer(_ layer: ImageLayer, scale: CGFloat) {
        let size: CGSize
        let coordinates: Coordinates
        
        // Scale the size and coordinates
        if layer.editable, let croppedSize = layer.croppedSize, let croppedCoordinates = layer.croppedCoordinates {
            size = CGSize(width: CGFloat(croppedSize.width) * scale, height: CGFloat(croppedSize.height) * scale)
            coordinates = croppedCoordinates
        } else {
            size = CGSize(width: CGFloat(layer.size.width) * scale, height: CGFloat(layer.size.height) * scale)
            coordinates = layer.coordinates
        }
        
        // Create and scale the image view
        if let imageName = layer.imageFile, let image = UIImage(named: imageName) {
            let imageView =  UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = layer.editable
            
            // If editable, wrap the imageView inside a resizable view
            if layer.editable {
                // Create frame for the resizable view using coordinates and size
                let imageFrame = CGRect(x: CGFloat(coordinates.x) * scale,
                                        y: CGFloat(coordinates.y) * scale,
                                        width: size.width,
                                        height: size.height)
                
                let resizableImageView = RKUserResizableView(frame: imageFrame)
                resizableImageView.id = layer.id
                resizableImageView.contentView = imageView
                resizableImageView.delegate = self
                contentView.addSubview(resizableImageView)
                
            } else {
                // If not editable, position the imageView directly with frames
                let imageFrame = CGRect(x: CGFloat(coordinates.x) * scale,
                                        y: CGFloat(coordinates.y) * scale,
                                        width: size.width,
                                        height: size.height)
                imageView.frame = imageFrame
                contentView.addSubview(imageView)
            }
        }
    }
    
    
    private func addTextLayer(_ layer: TextLayer, scale: CGFloat) {
        guard let textBoxCoordinates = layer.textBoxCoordinates else { return }
        
        let scaledTextBoxWidth = CGFloat(textBoxCoordinates.width) * scale
        let scaledTextBoxHeight = CGFloat(textBoxCoordinates.height) * scale
        let label = createTextView(for: layer, scale: scale)
        
        // Check if the layer is editable and apply resizable logic
        if layer.editable {
            // Use frame to position the resizable text view
            let resizableTextView = RKUserResizableView(frame: CGRect(x: CGFloat(textBoxCoordinates.x) * scale,
                                                                      y: CGFloat(textBoxCoordinates.y) * scale,
                                                                      width: scaledTextBoxWidth,
                                                                      height: scaledTextBoxHeight + 40))
            resizableTextView.contentView = label
            resizableTextView.id = layer.id
            resizableTextView.delegate = self
            contentView.addSubview(resizableTextView)
            
        } else {
            // Position the label directly with a frame if not editable
            label.frame = CGRect(x: CGFloat(textBoxCoordinates.x) * scale,
                                 y: CGFloat(textBoxCoordinates.y) * scale,
                                 width: scaledTextBoxWidth,
                                 height: scaledTextBoxHeight)
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
                                     height: scaledTextBoxHeight + 40)
        
        // Re-apply attributes to the text
        applyTextAttributes(to: label, layer: layer, scale: scale)
    }
    
    // Helper method to create the text view with initial configuration
    private func createTextView(for layer: TextLayer, scale: CGFloat) -> UITextView {
        let label = UITextView()
        label.isScrollEnabled = false
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        
        // Apply text and attributes
        label.text = layer.textValue
        applyTextAttributes(to: label, layer: layer, scale: scale)
        
        return label
    }
    
    private func applyTextAttributes(to label: UITextView, layer: TextLayer, scale: CGFloat) {
        let scaledFontSize = CGFloat(layer.fontSize ?? 131.4) * scale
        let attributedString = NSMutableAttributedString(string: label.text ?? "")
        
        // Apply font
        if let fontName = layer.font, let font = UIFont(name: fontName, size: scaledFontSize) {
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        } else {
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: scaledFontSize), range: NSRange(location: 0, length: attributedString.length))
        }
        
        // Apply text color (with hex handling)
        if let hexColor = layer.textColor, let textColor = UIColor(hex: hexColor) {
            attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attributedString.length))
        } else {
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length)) // Default to white
        }
        
        // Apply text alignment and formatting
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment(from: layer.textAlignment)
        
        // Apply text formatting (all caps, lowercase, capitalized)
        let formattedText = formatText(label.text ?? "", basedOn: layer.textFormatting)
        attributedString.mutableString.setString(formattedText)
        
        // Apply letter spacing
        if let letterSpacing = layer.letterSpacing {
            attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length))
        }
        
        // Apply line height (adjust minimum and maximum line height to match the line spacing)
        if let lineHeight = layer.lineHeight {
            paragraphStyle.lineSpacing = CGFloat(lineHeight)
            paragraphStyle.minimumLineHeight = CGFloat(lineHeight) * scaledFontSize
            paragraphStyle.maximumLineHeight = CGFloat(lineHeight) * scaledFontSize
        }
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        // Ensure text container settings in UITextView do not interfere with line height
        label.textContainer.lineFragmentPadding = 0
        label.textContainerInset = .zero
        
        // Assign attributed string to the label
        label.attributedText = attributedString
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
    
}

extension TemplateEditorController: TemplateEditorViewInterface {
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
              let type = dataSource.getLayerType(for: id) else {
            bottomMenu.isHidden = true
            return
        }
        
        switch type {
        case .text:
            bottomMenu.isHidden = false
        case .image:
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
        print("begin", userResizableView.id)
        
        activeResizableView?.hideEditingHandles()
        
        // Set the new active view and show its handles
        activeResizableView = userResizableView
        userResizableView.showEditingHandles()
    }
    
    func userResizableViewDidEndEditing(_ userResizableView: RKUserResizableView) {
           guard let id = userResizableView.id, let scaleFactor = scaleFactor else { return }
           
           // Extract the actual (unscaled) coordinates and size by dividing by the scaleFactor
           let actualCoordinates = Coordinates(
               x: Int(userResizableView.frame.origin.x / scaleFactor),
               y: Int(userResizableView.frame.origin.y / scaleFactor)
           )
           let actualSize = Size(
               width: Int(userResizableView.frame.size.width / scaleFactor),
               height: Int(userResizableView.frame.size.height / scaleFactor)
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
        fontSelectionView.isHidden.toggle()
        print("Font size reset to default")
        // Handle resetting the font size, maybe set the default size on the active layer
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
        fontSelectionView.isHidden.toggle()
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
        eventHandler.resetAlignment(for: id)
        eventHandler.resetTextFormating(for: id)
        fontSelectionView.isHidden.toggle()
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
        fontSelectionView.isHidden.toggle()
        // Handle reset logic
    }
}
