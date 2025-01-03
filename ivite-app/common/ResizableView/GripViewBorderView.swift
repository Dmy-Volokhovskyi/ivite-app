//
//  GripViewBorderView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 24/09/2024.
//

import UIKit

class GripViewBorderView: UIView {
    
    /// Accent color for borders and handles.
    var accentColor: UIColor = .accent
    
    /// Whether user is actively editing (shows solid border + handles).
    var isActive: Bool = false
    
    /// The size of the interactive handles.
    let handleSize: CGFloat = 10.0
    
    /// Call this from your `RKUserResizableView` to switch between active/inactive states.
    func setBorderActive(_ active: Bool) {
        isActive = active
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        // Common stroke color (accent)
        context.setStrokeColor(accentColor.cgColor)
        
        // Adjusted bounds for borders to prevent clipping
        let adjustedBounds = bounds.insetBy(dx: handleSize, dy: handleSize)
        
        if isActive {
            // --- ACTIVE STATE ---
            // (1) Solid border around the entire view.
            context.setLineWidth(1.0)
            context.setLineDash(phase: 0, lengths: []) // No dash
            context.addRect(adjustedBounds)
            context.strokePath()
            
            // (2) Draw the anchor points (resizing handles).
            let anchorRects = [
                CGRect(x: adjustedBounds.minX - handleSize / 2, y: adjustedBounds.minY - handleSize / 2, width: handleSize, height: handleSize), // upper-left
                CGRect(x: adjustedBounds.maxX - handleSize / 2, y: adjustedBounds.minY - handleSize / 2, width: handleSize, height: handleSize), // upper-right
                CGRect(x: adjustedBounds.maxX - handleSize / 2, y: adjustedBounds.maxY - handleSize / 2, width: handleSize, height: handleSize), // lower-right
                CGRect(x: adjustedBounds.minX - handleSize / 2, y: adjustedBounds.maxY - handleSize / 2, width: handleSize, height: handleSize), // lower-left
                
                // Middle points (optional)
                CGRect(x: adjustedBounds.midX - handleSize / 2, y: adjustedBounds.minY - handleSize / 2, width: handleSize, height: handleSize), // upper-middle
                CGRect(x: adjustedBounds.midX - handleSize / 2, y: adjustedBounds.maxY - handleSize / 2, width: handleSize, height: handleSize), // lower-middle
                CGRect(x: adjustedBounds.minX - handleSize / 2, y: adjustedBounds.midY - handleSize / 2, width: handleSize, height: handleSize), // middle-left
                CGRect(x: adjustedBounds.maxX - handleSize / 2, y: adjustedBounds.midY - handleSize / 2, width: handleSize, height: handleSize)  // middle-right
            ]
            
            // Fill/stroke handles
            context.setFillColor(accentColor.cgColor)
            context.setLineWidth(2)
            for anchorRect in anchorRects {
                context.saveGState()
                context.addEllipse(in: anchorRect)
                context.drawPath(using: .fillStroke)
                context.restoreGState()
            }
            
        } else {
            // --- INACTIVE STATE ---
            // Dashed border, no handles.
            let dashPattern: [CGFloat] = [4, 3]
            context.setLineWidth(2.0)
            context.setLineDash(phase: 0, lengths: dashPattern)
            context.addRect(adjustedBounds)
            context.strokePath()
        }
        
        context.restoreGState()
    }
}


