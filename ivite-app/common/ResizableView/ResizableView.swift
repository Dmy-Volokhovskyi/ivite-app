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
    var minWidth: CGFloat = 48.0
    var minHeight: CGFloat = 48.0
    /*private(set)*/ var currentRotation: CGFloat = 0.0
    var isEditingEnabled: Bool = false

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
        borderView.setBorderActive(true)
        rotationButton?.isHidden = false
    }
    
    func hideEditingHandles() {
        borderView.setBorderActive(false)
        rotationButton?.isHidden = true
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
        guard let superview = self.superview else { return }
        
        let locationInSuperview = recognizer.location(in: superview)
        let centerOfView = self.center
        let angle = atan2(locationInSuperview.y - centerOfView.y,
                          locationInSuperview.x - centerOfView.x)
        
        switch recognizer.state {
        case .began:
            originalTransform = self.transform
            initialRotation = currentRotation
            initialTouchAngle = angle
        case .changed:
            let deltaAngle = angle - initialTouchAngle
            currentRotation = initialRotation + deltaAngle
            let rotationTransform = CGAffineTransform(rotationAngle: currentRotation)
            self.transform = originalTransform.concatenating(rotationTransform)
        default:
            break
        }
    }
    
    // MARK: - Touches (Resizing & Moving)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        delegate?.userResizableViewDidBeginEditing(self)
        showEditingHandles()
        guard let touch = touches.first else { return }
        let pointInSelf = touch.location(in: self)
        resizeAnchorPoint = anchorPoint(forTouchLocation: pointInSelf)
        if isResizing() {
            if let superview = superview {
                touchStart = touch.location(in: superview)
            }
        } else {
            touchStart = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let superview = superview,
              let touch = touches.first else { return }
        if isResizing(), let anchor = resizeAnchorPoint {
            let touchLocationInSuperview = touch.location(in: superview)
            resize(usingTouchLocation: touchLocationInSuperview, anchor: anchor)
        } else {
            let pointInSelf = touch.location(in: self)
            translate(usingTouchLocation: pointInSelf)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.userResizableViewDidEndEditing(self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        let newCenter = CGPoint(
            x: center.x + touchPoint.x - touchStart.x,
            y: center.y + touchPoint.y - touchStart.y
        )
        if preventsPositionOutsideSuperview, let sv = superview {
            let midX = bounds.midX
            let midY = bounds.midY
            let maxX = sv.bounds.width - midX
            let maxY = sv.bounds.height - midY
            let clampedX = min(max(newCenter.x, midX), maxX)
            let clampedY = min(max(newCenter.y, midY), maxY)
            center = CGPoint(x: clampedX, y: clampedY)
        } else {
            center = newCenter
        }
    }
    
    private func resize(usingTouchLocation touchPoint: CGPoint, anchor: RKUserResizableViewAnchorPoint) {
        guard let superview = superview else { return }
        
        // Save the current transform and reset to identity for resizing
        let currentTransform = self.transform
        self.transform = .identity
        
        var localTouch = touchPoint
        if preventsPositionOutsideSuperview {
            localTouch.x = max(0, min(localTouch.x, superview.bounds.width))
            localTouch.y = max(0, min(localTouch.y, superview.bounds.height))
        }
        
        let deltaW = anchor.adjustsW * (touchStart.x - localTouch.x)
        let deltaH = anchor.adjustsH * (localTouch.y - touchStart.y)
        let deltaX = anchor.adjustsX * (-deltaW)
        let deltaY = anchor.adjustsY * (-deltaH)
        
        var newX = frame.origin.x + deltaX
        var newY = frame.origin.y + deltaY
        var newWidth = frame.size.width + deltaW
        var newHeight = frame.size.height + deltaH
        
        // Enforce minimum size
        if newWidth < minWidth {
            newWidth = frame.width
            newX = frame.origin.x
        }
        if newHeight < minHeight {
            newHeight = frame.height
            newY = frame.origin.y
        }
        
        // Clamp inside superview
        if preventsPositionOutsideSuperview {
            if newX < 0 { newX = 0 }
            if newY < 0 { newY = 0 }
            if newX + newWidth > superview.bounds.width {
                newWidth = superview.bounds.width - newX
            }
            if newY + newHeight > superview.bounds.height {
                newHeight = superview.bounds.height - newY
            }
        }
        
        // Update the frame
        self.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        _contentView?.frame = self.bounds.insetBy(dx: handleSize / 2, dy: handleSize / 2)
        borderView.frame = bounds
        borderView.setNeedsDisplay()
        
        // Restore the original transform
        self.transform = currentTransform
        
        // Update touchStart for the next calculation
        touchStart = localTouch
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
        // Check if the point is inside the rotation button
        if let rotationButton = rotationButton,
           rotationButton.frame.contains(convert(point, to: self)) {
            return rotationButton
        }
        
        // Check if the point is inside any of the handle (anchor) areas
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
                CGRect(x: bounds.width - buffer / 2, y: (bounds.height - buffer) / 2, width: buffer, height: buffer) // middle-right
            ]
            
            for anchorRect in anchorRects {
                if anchorRect.contains(convert(point, to: self)) {
                    return self // Return the view itself to handle resizing
                }
            }
        }
        
        return super.hitTest(point, with: event)
    }
    
    deinit {
        _contentView?.removeFromSuperview()
    }
}
