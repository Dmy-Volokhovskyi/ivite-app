//
//  UIView+SketchShadow.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 02/12/2024.
//

import UIKit

extension UIView {
    func applySketchShadow(color: UIColor = .black,
                           alpha: Float = 0.2,
                           valueX: CGFloat = 0,
                           valueY: CGFloat = 2,
                           blur: CGFloat = 4,
                           spread: CGFloat = 0,
                           cornerRadius: CGFloat = 12) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: valueX, height: valueY)
        layer.shadowRadius = blur / 2
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let directionX = -spread
            let rect = bounds.insetBy(dx: directionX, dy: directionX)
            layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
    }
}
