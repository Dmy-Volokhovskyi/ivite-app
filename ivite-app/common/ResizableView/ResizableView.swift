//
//  ResizableView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 22/09/2024.
//
import UIKit

// MARK: - Anchor Point Structs

struct RKUserResizableViewAnchorPoint {
    var adjustsX: CGFloat = 0.0
    var adjustsY: CGFloat = 0.0
    var adjustsH: CGFloat = 0.0
    var adjustsW: CGFloat = 0.0
}

struct RKUserResizableViewAnchorPointPair {
    var point: CGPoint = CGPoint.zero
    var resizeAnchorPoint: RKUserResizableViewAnchorPoint = RKUserResizableViewAnchorPoint()
}

// MARK: - Protocol

protocol RKUserResizableViewDelegate: AnyObject {
    func userResizableViewDidBeginEditing(_ userResizableView: RKUserResizableView)
    func userResizableViewDidEndEditing(_ userResizableView: RKUserResizableView)
}

// MARK: - RKUserResizableView Class

class RKUserResizableView: UIView {
    
    // MARK: - Public Properties
    
    var preventsPositionOutsideSuperview: Bool = true
    weak var delegate: RKUserResizableViewDelegate?
    var minWidth: CGFloat = 8.0
    var minHeight: CGFloat = 8.0
    /*private(set)*/ var currentRotation: CGFloat = 0.0
    var isEditingEnabled: Bool = false
    private var gestureBeganToSelect = false
    var forceHideEditingHandles: Bool = false {
        didSet {
            updateEditingHandlesVisibility()
        }
    }
    var presetRotation: CGFloat = 0.0 {
        didSet {
            // When presetRotation is changed, update the internal rotation state
            // and apply the corresponding rotation transform.
            currentRotation = presetRotation
            self.transform = CGAffineTransform(rotationAngle: currentRotation)
        }
    }

    var id: String?
    
    // MARK: - Private Properties
    
    private var _contentView: UIView?
    private lazy var borderView: GripViewBorderView = {
        let view = GripViewBorderView(frame: self.bounds)
        view.backgroundColor = .clear
        view.setBorderActive(false)
        addSubview(view)
        return view
    }()
    private var rotationButton: UIButton?
    private var resizeAnchorPoint: RKUserResizableViewAnchorPoint?
    private var touchStart = CGPoint.zero
    private var initialRotation: CGFloat = 0.0
    private var initialTouchAngle: CGFloat = 0.0
    private let handleSize: CGFloat = 10.0
    private var originalTransform: CGAffineTransform = .identity
    
    // MARK: - Constants
    
    let globalInset: CGFloat = 5.0
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame) // Keep exactly what the user provides
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupDefaults()
    }
    
    // MARK: - Setup & Layout
    
    private func setupDefaults() {
        bringSubviewToFront(borderView)
        clipsToBounds = false
        borderView.clipsToBounds = false
        setupRotationButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderView.frame = self.bounds.insetBy(dx: -handleSize / 2, dy: -handleSize / 2)
        borderView.setNeedsDisplay()
        
        if let rotationButton = rotationButton {
            let buttonWidth = rotationButton.bounds.width
            let centerX = (bounds.width - buttonWidth) / 2
            let belowViewY = bounds.height + 8
            rotationButton.frame = CGRect(x: centerX,
                                          y: belowViewY,
                                          width: buttonWidth,
                                          height: rotationButton.bounds.height)
            bringSubviewToFront(rotationButton)
        }
    }
    
    var contentView: UIView? {
        get { _contentView }
        set {
            _contentView?.removeFromSuperview()
            _contentView = newValue
            if let cv = _contentView {
                cv.frame = self.bounds
                addSubview(cv)
                bringSubviewToFront(borderView)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func setViewFrame(_ newFrame: CGRect) {
        self.frame = newFrame
        _contentView?.frame = self.bounds.insetBy(dx: handleSize / 2, dy: handleSize / 2)
        borderView.frame = self.bounds.insetBy(dx: -handleSize / 2, dy: -handleSize / 2)
        borderView.setNeedsDisplay()
    }
    
    func showEditingHandles() {
        // Only show editing handles if we’re not forcing them to be hidden.
        guard !forceHideEditingHandles else {
            borderView.isHidden = true
            rotationButton?.isHidden = true
            return
        }
        borderView.isHidden = false
        borderView.setBorderActive(true)
        rotationButton?.isHidden = false
    }
    
    func hideEditingHandles() {
        borderView.setBorderActive(false)
        rotationButton?.isHidden = true
    }
    
    private func updateEditingHandlesVisibility() {
        if forceHideEditingHandles {
            // Force hide them completely.
            borderView.isHidden = true
            rotationButton?.isHidden = true
        } else {
            // Otherwise, restore the proper state based on isEditingEnabled.
            if isEditingEnabled {
                borderView.isHidden = false
                borderView.setBorderActive(true)
                rotationButton?.isHidden = false
            } else {
                borderView.isHidden = false  // Visible but drawn as inactive (dashed)
                borderView.setBorderActive(false)
                rotationButton?.isHidden = true
            }
        }
    }

    
    // MARK: - Rotation Handling
    
    private func setupRotationButton() {
        if rotationButton == nil {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.layer.cornerRadius = 15
            button.backgroundColor = .white
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
            button.addGestureRecognizer(pan)
            button.isHidden = true
            rotationButton = button
            addSubview(button)
        }
    }
    
    @objc private func handleRotationGesture(_ recognizer: UIPanGestureRecognizer) {
        guard !forceHideEditingHandles else { return }
        // Only allow rotation if the view is selected (editing is enabled)
        guard isEditingEnabled else { return }
        guard let superview = self.superview else { return }
        
        // Get the touch location in the superview's coordinate space.
        let locationInSuperview = recognizer.location(in: superview)
        let centerOfView = self.center
        let angle = atan2(locationInSuperview.y - centerOfView.y,
                          locationInSuperview.x - centerOfView.x)
        
        switch recognizer.state {
        case .began:
            // Use currentRotation as the baseline.
            initialRotation = currentRotation
            initialTouchAngle = angle
        case .changed:
            let deltaAngle = angle - initialTouchAngle
            currentRotation = initialRotation + deltaAngle
            self.transform = CGAffineTransform(rotationAngle: currentRotation)
        default:
            break
        }
    }

    // MARK: - Touches (Resizing & Moving)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard !forceHideEditingHandles else { return }
        guard let touch = touches.first, let sv = self.superview else { return }
        // If the view is not selected, use this gesture to select it and ignore movement/resizing.
        if !isEditingEnabled {
            isEditingEnabled = true
            showEditingHandles()
            delegate?.userResizableViewDidBeginEditing(self)
            gestureBeganToSelect = true
            // Record the starting touch point in the superview's coordinate space.
            touchStart = touch.location(in: sv)
            return
        }
        
        // The view is already selected. Clear the selection flag.
        gestureBeganToSelect = false
        
        // Determine if the touch is on a handle (resizing) or not.
        let pointInSelf = touch.location(in: self)
        resizeAnchorPoint = anchorPoint(forTouchLocation: pointInSelf)
        
        // Always record the starting touch point in the superview's coordinate space.
        touchStart = touch.location(in: sv)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let sv = self.superview else { return }
        guard !forceHideEditingHandles else { return }
        // If this gesture was used to select the view, do not allow movement/resizing.
        if gestureBeganToSelect {
            return
        }
        
        // Always use superview coordinates.
        let currentTouchPoint = touch.location(in: sv)
        
        // If a resize handle is active, perform resizing; otherwise, translate.
        if let anchor = resizeAnchorPoint, isResizing() {
            resize(usingTouchLocation: currentTouchPoint, anchor: anchor)
        } else {
            translate(usingTouchLocation: currentTouchPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureBeganToSelect = false
        delegate?.userResizableViewDidEndEditing(self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureBeganToSelect = false
        delegate?.userResizableViewDidEndEditing(self)
    }

    // MARK: - Movement & Resizing Logic
    
    private func isResizing() -> Bool {
        guard let anchor = resizeAnchorPoint else { return false }
        return (anchor.adjustsH != 0 ||
                anchor.adjustsW != 0 ||
                anchor.adjustsX != 0 ||
                anchor.adjustsY != 0)
    }
    
    private func translate(usingTouchLocation touchPoint: CGPoint) {
        guard !forceHideEditingHandles else { return }
        let newCenter = CGPoint(
            x: center.x + (touchPoint.x - touchStart.x),
            y: center.y + (touchPoint.y - touchStart.y)
        )
        
        if preventsPositionOutsideSuperview, let sv = self.superview {
            let midX = bounds.midX
            let midY = bounds.midY
            let maxX = sv.bounds.width - midX
            let maxY = sv.bounds.height - midY
            center = CGPoint(
                x: min(max(newCenter.x, midX), maxX),
                y: min(max(newCenter.y, midY), maxY)
            )
        } else {
            center = newCenter
        }
        
        // Update touchStart so that movement is continuous.
        touchStart = touchPoint
    }
    
    private func resize(usingTouchLocation touchPoint: CGPoint, anchor: RKUserResizableViewAnchorPoint) {
        guard let sv = self.superview else { return }
        
        // 1. Save the view's current center in superview coordinates BEFORE removing the transform.
        let savedCenter = self.center
        
        // 2. Save and reset the transform so resizing math works in the view's unrotated space.
        let currentTransform = self.transform
        self.transform = .identity
        
        // 3. Convert both the original touchStart and the current touchPoint (from superview) to our local coordinate system.
        // Then apply the inverse rotation.
        let inverseRotation = CGAffineTransform(rotationAngle: -currentRotation)
        let unrotatedTouchStart = self.convert(touchStart, from: sv).applying(inverseRotation)
        let unrotatedTouchPoint = self.convert(touchPoint, from: sv).applying(inverseRotation)
        
        // 4. Calculate the delta for width and height using the unrotated coordinates.
        let deltaW = anchor.adjustsW * (unrotatedTouchStart.x - unrotatedTouchPoint.x)
        let deltaH = anchor.adjustsH * (unrotatedTouchPoint.y - unrotatedTouchStart.y)
        
        // 5. Compute new width and height.
        let newWidth = frame.size.width + deltaW
        let newHeight = frame.size.height + deltaH
        
        // 6. Enforce minimum sizes.
        let adjustedWidth = max(newWidth, minWidth)
        let adjustedHeight = max(newHeight, minHeight)
        
        // 7. Create a new frame using the saved center so the view's center does not drift.
        var newFrame = CGRect(
            x: savedCenter.x - adjustedWidth / 2,
            y: savedCenter.y - adjustedHeight / 2,
            width: adjustedWidth,
            height: adjustedHeight
        )
        
        // 8. (Optional) Clamp newFrame inside the superview’s bounds only if preventsPositionOutsideSuperview is true.
        if preventsPositionOutsideSuperview {
            if newFrame.origin.x < 0 { newFrame.origin.x = 0 }
            if newFrame.origin.y < 0 { newFrame.origin.y = 0 }
            if newFrame.maxX > sv.bounds.width {
                newFrame.size.width = sv.bounds.width - newFrame.origin.x
                newFrame.origin.x = sv.bounds.width - newFrame.size.width
            }
            if newFrame.maxY > sv.bounds.height {
                newFrame.size.height = sv.bounds.height - newFrame.origin.y
                newFrame.origin.y = sv.bounds.height - newFrame.size.height
            }
        }
        
        // 9. Update the frame and subviews.
        self.frame = newFrame
        _contentView?.frame = self.bounds.insetBy(dx: handleSize / 2, dy: handleSize / 2)
        borderView.frame = self.bounds.insetBy(dx: -handleSize / 2, dy: -handleSize / 2)
        borderView.setNeedsDisplay()
        
        // 10. Restore the original rotation.
        self.transform = currentTransform
        
        // 11. Update touchStart (in superview coordinates) for continuous resizing.
        touchStart = touchPoint
    }

    private func anchorPoint(forTouchLocation touchPoint: CGPoint) -> RKUserResizableViewAnchorPoint {
        let noAnchor = RKUserResizableViewAnchorPoint()
        let buffer: CGFloat = handleSize
        let leftEdge   = (touchPoint.x < buffer)
        let rightEdge  = (touchPoint.x > bounds.width - buffer)
        let topEdge    = (touchPoint.y < buffer)
        let bottomEdge = (touchPoint.y > bounds.height - buffer)
        if leftEdge && topEdge {
            return RKUserResizableViewAnchorPoint(adjustsX: 1, adjustsY: 1, adjustsH: -1, adjustsW: 1)
        } else if rightEdge && topEdge {
            return RKUserResizableViewAnchorPoint(adjustsX: 0, adjustsY: 1, adjustsH: -1, adjustsW: -1)
        } else if rightEdge && bottomEdge {
            return RKUserResizableViewAnchorPoint(adjustsX: 0, adjustsY: 0, adjustsH: 1, adjustsW: -1)
        } else if leftEdge && bottomEdge {
            return RKUserResizableViewAnchorPoint(adjustsX: 1, adjustsY: 0, adjustsH: 1, adjustsW: 1)
        }
        if leftEdge {
            return RKUserResizableViewAnchorPoint(adjustsX: 1, adjustsY: 0, adjustsH: 0, adjustsW: 1)
        } else if rightEdge {
            return RKUserResizableViewAnchorPoint(adjustsX: 0, adjustsY: 0, adjustsH: 0, adjustsW: -1)
        } else if topEdge {
            return RKUserResizableViewAnchorPoint(adjustsX: 0, adjustsY: 1, adjustsH: -1, adjustsW: 0)
        } else if bottomEdge {
            return RKUserResizableViewAnchorPoint(adjustsX: 0, adjustsY: 0, adjustsH: 1, adjustsW: 0)
        }
        return noAnchor
    }
    
    // MARK: - Hit Testing for Rotation Button
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If the view is not selected, do not allow interaction with the rotation button.
        if !isEditingEnabled {
            return super.hitTest(point, with: event)
        }
        
        // Check if the point is inside the rotation button.
        if let rotationButton = rotationButton,
           rotationButton.frame.contains(convert(point, to: self)) {
            return rotationButton
        }
        
        // Check if the point is inside any of the handle areas.
        if borderView.isActive {
            let buffer: CGFloat = handleSize
            let anchorRects = [
                CGRect(x: -buffer / 2, y: -buffer / 2, width: buffer, height: buffer), // upper-left
                CGRect(x: bounds.width - buffer / 2, y: -buffer / 2, width: buffer, height: buffer), // upper-right
                CGRect(x: bounds.width - buffer / 2, y: bounds.height - buffer / 2, width: buffer, height: buffer), // lower-right
                CGRect(x: -buffer / 2, y: bounds.height - buffer / 2, width: buffer, height: buffer), // lower-left
                
                // Middle points
                CGRect(x: (bounds.width - buffer) / 2, y: -buffer / 2, width: buffer, height: buffer), // upper-middle
                CGRect(x: (bounds.width - buffer) / 2, y: bounds.height - buffer / 2, width: buffer, height: buffer), // lower-middle
                CGRect(x: -buffer / 2, y: (bounds.height - buffer) / 2, width: buffer, height: buffer), // middle-left
                CGRect(x: bounds.width - buffer / 2, y: (bounds.height - buffer) / 2, width: buffer, height: buffer)  // middle-right
            ]
            
            for anchorRect in anchorRects {
                if anchorRect.contains(convert(point, to: self)) {
                    return self
                }
            }
        }
        
        return super.hitTest(point, with: event)
    }
    
    deinit {
        _contentView?.removeFromSuperview()
    }
}
