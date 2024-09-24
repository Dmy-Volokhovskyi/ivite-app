//
//  ResizableView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 22/09/2024.
//

import UIKit

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

protocol RKUserResizableViewDelegate: NSObjectProtocol {
    // Called when the resizable view receives touchesBegan: and activates the editing handles.
    func userResizableViewDidBeginEditing(_ userResizableView: RKUserResizableView)
    
    // Called when the resizable view receives touchesEnded: or touchesCancelled:
    func userResizableViewDidEndEditing(_ userResizableView: RKUserResizableView)
}

class RKUserResizableView:UIView {
    
    var borderView: GripViewBorderView?
    
    // Will be retained as a subview.
    var _contentView: UIView?
    var id: String?
    
    var contentView:UIView? {
        set (newValue) {
            newValue?.removeFromSuperview()
            newValue?.frame = bounds.insetBy(dx: RKUserResizableViewGlobalInset + RKUserResizableViewInteractiveBorderSize / 2, dy: RKUserResizableViewGlobalInset + RKUserResizableViewInteractiveBorderSize / 2)
            addSubview(newValue!)
            // Ensure the border view is always on top by removing it and adding it to the end of the subview list.
            borderView?.removeFromSuperview()
            addSubview(borderView!)
            self._contentView = newValue
        }
        get {
            return self._contentView
        }
    }
    
    var rotationButton: UIButton?
    var currentRotation: CGFloat = 0.0
    
    var touchStart = CGPoint.zero
    
    // Default is 48.0 for each.
    var minWidth: CGFloat = 48.0
    var minHeight: CGFloat = 48.0
    
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    var resizeAnchorPoint = RKUserResizableViewAnchorPoint()
    
    weak var delegate: RKUserResizableViewDelegate?
    
    /* Let's inset everything that's drawn (the handles and the content view)
     so that users can trigger a resize from a few pixels outside of
     what they actually see as the bounding box. */
    let RKUserResizableViewGlobalInset:CGFloat = 5.0
    let RKUserResizableViewDefaultMinWidth:CGFloat = 48.0
    let RKUserResizableViewDefaultMinHeight:CGFloat = 48.0
    let RKUserResizableViewInteractiveBorderSize:CGFloat = 10.0
    
    // Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
    
    var isPreventsPositionOutsideSuperview: Bool = false
    
    private var RKUserResizableViewNoResizeAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 0.0, adjustsY: 0.0, adjustsH: 0.0, adjustsW: 0.0)
    private var RKUserResizableViewUpperLeftAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 1.0, adjustsY: 1.0, adjustsH: -1.0, adjustsW: 1.0)
    private var RKUserResizableViewMiddleLeftAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 1.0, adjustsY: 0.0, adjustsH: 0.0, adjustsW: 1.0)
    private var RKUserResizableViewLowerLeftAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 1.0, adjustsY: 0.0, adjustsH: 1.0, adjustsW: 1.0)
    private var RKUserResizableViewUpperMiddleAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 0.0, adjustsY: 1.0, adjustsH: -1.0, adjustsW: 0.0)
    private var RKUserResizableViewUpperRightAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 0.0, adjustsY: 1.0, adjustsH: -1.0, adjustsW: -1.0)
    private var RKUserResizableViewMiddleRightAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 0.0, adjustsY: 0.0, adjustsH: 0.0, adjustsW: -1.0)
    private var RKUserResizableViewLowerRightAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 0.0, adjustsY: 0.0, adjustsH: 1.0, adjustsW: -1.0)
    private var RKUserResizableViewLowerMiddleAnchorPoint = RKUserResizableViewAnchorPoint(adjustsX: 0.0, adjustsY: 0.0, adjustsH: 1.0, adjustsW: 0.0)
    
    func setupDefaultAttributes() {
        borderView = GripViewBorderView(frame: bounds.insetBy(dx: CGFloat(RKUserResizableViewGlobalInset), dy: CGFloat(RKUserResizableViewGlobalInset)))
        borderView?.isHidden = true
        self.addSubview(borderView!)
        minWidth = RKUserResizableViewDefaultMinWidth
        minHeight = RKUserResizableViewDefaultMinHeight
        isPreventsPositionOutsideSuperview = true
        setupRotationButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaultAttributes()
    }
    
    func setViewFrame(_ newFrame: CGRect) {
        self.frame = newFrame
        contentView?.frame = bounds.insetBy(dx: RKUserResizableViewGlobalInset + RKUserResizableViewInteractiveBorderSize / 2, dy: RKUserResizableViewGlobalInset + RKUserResizableViewInteractiveBorderSize / 2)
        borderView?.frame = bounds.insetBy(dx: RKUserResizableViewGlobalInset, dy: RKUserResizableViewGlobalInset)
        borderView?.setNeedsDisplay()
    }
    
    func setupRotationButton() {
        if rotationButton == nil {
            rotationButton = UIButton(type: .system)
            rotationButton?.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal) // Circular arrow icon
            rotationButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // Set the size initially
            rotationButton?.layer.cornerRadius = 15
            rotationButton?.backgroundColor = .white
            rotationButton?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:))))
            addSubview(rotationButton!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Calculate the center X point for the rotation button
        let centerX = bounds.width / 2 - 15  // Subtract half the button's width (15 for a 30x30 button)

        // Place the button a few pixels below the view's bottom edge (e.g., 10 pixels below)
        let belowViewY = bounds.height + 10  // Add a 10-pixel gap below the view's bottom edge

        // Set the rotation button frame
        rotationButton?.frame = CGRect(x: centerX, y: belowViewY, width: 30, height: 30)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if the point is inside the rotation button, even if it is outside the main view bounds
        if let rotationButton = rotationButton, rotationButton.frame.contains(convert(point, to: self)) {
            return rotationButton
        }
        
        // Perform the default hit testing for other parts of the view
        return super.hitTest(point, with: event)
    }

    
    private func distanceBetweenTwoPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx: CGFloat = point2.x - point1.x
        let dy: CGFloat = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func anchorPoint(forTouchLocation touchPoint: CGPoint) -> RKUserResizableViewAnchorPoint {
        // (1) Calculate the positions of each of the anchor points.
        let upperLeft = RKUserResizableViewAnchorPointPair(point: CGPoint(x: 0.0, y: 0.0), resizeAnchorPoint: RKUserResizableViewUpperLeftAnchorPoint)
        
        let upperMiddle = RKUserResizableViewAnchorPointPair(point: CGPoint(x: bounds.size.width / 2, y: 0.0), resizeAnchorPoint: RKUserResizableViewUpperMiddleAnchorPoint)
        
        let upperRight = RKUserResizableViewAnchorPointPair(point: CGPoint(x: bounds.size.width, y: 0.0), resizeAnchorPoint: RKUserResizableViewUpperRightAnchorPoint)
        
        let middleRight = RKUserResizableViewAnchorPointPair(point: CGPoint(x: bounds.size.width, y: bounds.size.height / 2), resizeAnchorPoint: RKUserResizableViewMiddleRightAnchorPoint)
        
        let lowerRight = RKUserResizableViewAnchorPointPair(point: CGPoint(x: bounds.size.width, y: bounds.size.height), resizeAnchorPoint: RKUserResizableViewLowerRightAnchorPoint)
        
        let lowerMiddle = RKUserResizableViewAnchorPointPair(point: CGPoint(x: bounds.size.width / 2, y: bounds.size.height), resizeAnchorPoint: RKUserResizableViewLowerMiddleAnchorPoint)
        
        let lowerLeft = RKUserResizableViewAnchorPointPair(point: CGPoint(x: 0, y: bounds.size.height), resizeAnchorPoint: RKUserResizableViewLowerLeftAnchorPoint)
        
        let middleLeft = RKUserResizableViewAnchorPointPair(point: CGPoint(x: 0, y: bounds.size.height / 2), resizeAnchorPoint: RKUserResizableViewMiddleLeftAnchorPoint)
        
        let centerPoint = RKUserResizableViewAnchorPointPair(point: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2), resizeAnchorPoint: RKUserResizableViewNoResizeAnchorPoint)
        
        // (2) Iterate over each of the anchor points and find the one closest to the user's touch.
        let allPoints: [RKUserResizableViewAnchorPointPair] = [upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight, centerPoint]
        var smallestDistance: CGFloat = CGFloat(MAXFLOAT)
        var closestPoint: RKUserResizableViewAnchorPointPair = centerPoint
        for i in 0..<9 {
            let distance: CGFloat = distanceBetweenTwoPoints(point1: touchPoint, point2: allPoints[i].point)
            if distance < smallestDistance {
                closestPoint = allPoints[i]
                smallestDistance = distance
            }
        }
        return closestPoint.resizeAnchorPoint
    }
    
    func isResizing() -> Bool {
        return (resizeAnchorPoint.adjustsH != 0 || resizeAnchorPoint.adjustsW != 0 || resizeAnchorPoint.adjustsX != 0 || resizeAnchorPoint.adjustsY != 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // Notify the delegate we've begun our editing session.
        //        if delegate?.responds(to: #selector(self.userResizableViewDidBeginEditing)) {
        delegate?.userResizableViewDidBeginEditing(self)
        //        }
        borderView?.isHidden = false
        
        if let touch = touches.first {
            resizeAnchorPoint = anchorPoint(forTouchLocation: touch.location(in: self))
            print(resizeAnchorPoint)
            // When resizing, all calculations are done in the superview's coordinate space.
            touchStart = touch.location(in: superview)
            if !isResizing() {
                // When translating, all calculations are done in the view's coordinate space.
                touchStart = touch.location(in: self)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Notify the delegate we've ended our editing session.
        delegate?.userResizableViewDidEndEditing(self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Notify the delegate we've ended our editing session.
        delegate?.userResizableViewDidEndEditing(self)
    }
    
    func showEditingHandles() {
        borderView?.isHidden = false
    }
    
    func hideEditingHandles() {
        borderView?.isHidden = true
    }
    
    func resize(usingTouchLocation touchPoint: CGPoint) {
        // (1) Update the touch point if we're outside the superview.
        /* disabled by rajat jain on 2017-08-28
         if isPreventsPositionOutsideSuperview {
         let border: CGFloat = RKUserResizableViewGlobalInset + RKUserResizableViewInteractiveBorderSize / 2
         if touchPoint.x < border {
         touchPoint.x = border
         }
         if touchPoint.x > superview?.bounds.size.width - border {
         touchPoint.x = superview?.bounds.size.width - border
         }
         if touchPoint.y < border {
         touchPoint.y = border
         }
         if touchPoint.y > superview?.bounds.size.height - border {
         touchPoint.y = superview?.bounds.size.height - border
         }
         }
         */
        
        // (2) Calculate the deltas using the current anchor point.
        var deltaW: CGFloat = resizeAnchorPoint.adjustsW * (touchStart.x - touchPoint.x)
        let deltaX: CGFloat = resizeAnchorPoint.adjustsX * (-1.0 * deltaW)
        var deltaH: CGFloat = resizeAnchorPoint.adjustsH * (touchPoint.y - touchStart.y)
        let deltaY: CGFloat = resizeAnchorPoint.adjustsY * (-1.0 * deltaH)
        // (3) Calculate the new frame.
        var newX: CGFloat = frame.origin.x + deltaX
        var newY: CGFloat = frame.origin.y + deltaY
        var newWidth: CGFloat = frame.size.width + deltaW
        var newHeight: CGFloat = frame.size.height + deltaH
        // (4) If the new frame is too small, cancel the changes.
        if newWidth < minWidth {
            newWidth = frame.size.width
            newX = frame.origin.x
        }
        if newHeight < minHeight {
            newHeight = frame.size.height
            newY = frame.origin.y
        }
        
        // (5) Ensure the resize won't cause the view to move offscreen.
        if isPreventsPositionOutsideSuperview {
            if let superView = self.superview {
                if newX < superView.bounds.origin.x {
                    // Calculate how much to grow the width by such that the new X coordintae will align with the superview.
                    deltaW = self.frame.origin.x - superView.bounds.origin.x
                    newWidth = self.frame.size.width + deltaW
                    newX = superView.bounds.origin.x
                }
                
                if newX + newWidth > superView.bounds.origin.x + superView.bounds.size.width {
                    newWidth = superView.bounds.size.width - newX
                }
                
                if newY < superView.bounds.origin.y {
                    // Calculate how much to grow the height by such that the new Y coordintae will align with the superview.
                    deltaH = self.frame.origin.y - superView.bounds.origin.y
                    newHeight = self.frame.size.height + deltaH
                    newY = superView.bounds.origin.y
                }
                
                if newY + newHeight > superView.bounds.origin.y + superView.bounds.size.height {
                    newHeight = superView.bounds.size.height - newY
                }
                
            }
        }
        
        self.setViewFrame(CGRect(x: newX, y: newY, width: newWidth, height: newHeight))
        
        touchStart = touchPoint
    }
    
    func translate(usingTouchLocation touchPoint: CGPoint) {
        
        let rotatedPoint = touchPoint.applying(CGAffineTransform(rotationAngle: -currentRotation))
        
        var newCenter = CGPoint(x: center.x + touchPoint.x - touchStart.x, y: center.y + touchPoint.y - touchStart.y)
        if isPreventsPositionOutsideSuperview {
            if let superView = self.superview {
                
                // Ensure the translation won't cause the view to move offscreen.
                let midPointX: CGFloat = bounds.midX
                if newCenter.x > superView.bounds.size.width - midPointX {
                    newCenter.x = superView.bounds.size.width - midPointX
                }
                if newCenter.x < midPointX {
                    newCenter.x = midPointX
                }
                let midPointY: CGFloat = bounds.midY
                if newCenter.y > superView.bounds.size.height - midPointY {
                    newCenter.y = superView.bounds.size.height - midPointY
                }
                if newCenter.y < midPointY {
                    newCenter.y = midPointY
                }
            }
        }
        center = newCenter
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isResizing() {
            if let superView = self.superview {
                resize(usingTouchLocation: (touches.first?.location(in: superView))!)
            }
        }
        else {
            translate(usingTouchLocation: (touches.first?.location(in: self))!)
        }
    }
    
    @objc func handleRotationGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let rotationButton = rotationButton else { return }
        
        let locationInSuperview = recognizer.location(in: self.superview)
        let centerOfView = self.center

        // Calculate angle between touch and the center of the view
        let angle = atan2(locationInSuperview.y - centerOfView.y, locationInSuperview.x - centerOfView.x)

        switch recognizer.state {
        case .began:
            break
        case .changed:
            // Apply the rotation by updating the transform of the view
            let rotationTransform = CGAffineTransform(rotationAngle: angle)
            self.transform = rotationTransform.concatenating(CGAffineTransform(translationX: self.frame.midX - centerOfView.x, y: self.frame.midY - centerOfView.y))

            currentRotation = angle // Store the current rotation value
        case .ended, .cancelled:
            break
        default:
            break
        }
    }
    
    deinit {
        contentView?.removeFromSuperview()
    }
}
