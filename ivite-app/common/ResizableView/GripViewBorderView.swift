//
//  GripViewBorderView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 24/09/2024.
//

import UIKit

class GripViewBorderView: UIView {
    
    let RKUserResizableViewGlobalInset:CGFloat = 5.0
    let RKUserResizableViewDefaultMinWidth:CGFloat = 48.0
    let RKUserResizableViewDefaultMinHeight:CGFloat = 48.0
    let RKUserResizableViewInteractiveBorderSize:CGFloat = 10.0
    
    weak var delegate: RKUserResizableViewDelegate?
    // Will be retained as a subview.
    var contentView: UIView?
    // Default is 48.0 for each.
    var minWidth: CGFloat = 0.0
    var minHeight: CGFloat = 0.0
    // Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
    var isPreventsPositionOutsideSuperview: Bool = false
    
    var borderView: GripViewBorderView?
    var touchStart = CGPoint.zero
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    var resizeAnchorPoint = RKUserResizableViewAnchorPoint()
    
    func hideEditingHandles() {
    }
    
    func showEditingHandles() {
    }
    
    override init(frame: CGRect) {
        // Clear background to ensure the content view shows through.
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        // (1) Draw the bounding box.
        context?.setLineWidth(1.0)
        context?.setStrokeColor(UIColor.blue.cgColor)
        context?.addRect(bounds.insetBy(dx: RKUserResizableViewInteractiveBorderSize / 2, dy: RKUserResizableViewInteractiveBorderSize / 2))
        context?.strokePath()
        
        // (2) Calculate the bounding boxes for each of the anchor points.
        let upperLeft = CGRect(x: 0.0, y: 0.0, width: RKUserResizableViewInteractiveBorderSize, height: RKUserResizableViewInteractiveBorderSize)
        let upperRight = CGRect(x: bounds.size.width - RKUserResizableViewInteractiveBorderSize, y: 0.0, width: RKUserResizableViewInteractiveBorderSize, height: RKUserResizableViewInteractiveBorderSize)
        let lowerRight = CGRect(x: bounds.size.width - RKUserResizableViewInteractiveBorderSize, y: bounds.size.height - RKUserResizableViewInteractiveBorderSize, width: RKUserResizableViewInteractiveBorderSize, height: RKUserResizableViewInteractiveBorderSize)
        let lowerLeft = CGRect(x: 0.0, y: bounds.size.height - RKUserResizableViewInteractiveBorderSize, width: RKUserResizableViewInteractiveBorderSize, height: RKUserResizableViewInteractiveBorderSize)
        let upperMiddle = CGRect(x: (bounds.size.width - RKUserResizableViewInteractiveBorderSize) / 2, y: 0.0, width: RKUserResizableViewInteractiveBorderSize, height: RKUserResizableViewInteractiveBorderSize)
        let lowerMiddle = CGRect(x: (bounds.size.width - RKUserResizableViewInteractiveBorderSize) / 2, y: bounds.size.height - RKUserResizableViewInteractiveBorderSize, width: RKUserResizableViewInteractiveBorderSize, height: RKUserResizableViewInteractiveBorderSize)
        let middleLeft = CGRect(x: 0.0, y: (bounds.size.height - RKUserResizableViewInteractiveBorderSize) / 2, width: RKUserResizableViewInteractiveBorderSize, height: RKUserResizableViewInteractiveBorderSize)
        let middleRight = CGRect(x: bounds.size.width - RKUserResizableViewInteractiveBorderSize, y: (bounds.size.height - RKUserResizableViewInteractiveBorderSize) / 2, width: RKUserResizableViewInteractiveBorderSize, height: RKUserResizableViewInteractiveBorderSize)
        
        // (3) Create the gradient to paint the anchor points.
        let colors: [CGFloat] = [0.4, 0.8, 1.0, 1.0, 0.0, 0.0, 1.0, 1.0]
        let baseSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let gradient: CGGradient = CGGradient(colorSpace: baseSpace!, colorComponents: colors, locations: nil, count: 2)!
        
        // (4) Set up the stroke for drawing the border of each of the anchor points.
        context?.setLineWidth(2)
        context!.setShadow(offset: CGSize(width: 0.5, height: 0.5), blur: 1)
        context?.setStrokeColor(UIColor.white.cgColor)
        
        // (5) Fill each anchor point using the gradient, then stroke the border.
        let allPoints: [CGRect] = [upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight]
        for i in 0..<8 {
            let currPoint: CGRect = allPoints[i]
            context?.saveGState()
            //context?.addEllipse(in: currPoint)
            let currentPoint = CGRect(x: currPoint.origin.x, y: currPoint.origin.y, width: 10, height: 10);
            context?.addEllipse(in: currentPoint)
            context?.clip()
            let startPoint = CGPoint(x: currentPoint.midX, y: currentPoint.minY)
            let endPoint = CGPoint(x: currentPoint.midX, y: currentPoint.maxY)
            context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
            context?.restoreGState()
            context?.strokeEllipse(in: currentPoint.insetBy(dx: 1, dy: 1))
        }
        context?.restoreGState()
    }
}
