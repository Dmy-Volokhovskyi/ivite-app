//
//  DividerView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import UIKit
import PureLayout

final class DividerView: BaseView {
    private var topSpace: CGFloat
    private var bottomSpace: CGFloat
    
    private let divider = UIView()
    
    // Initializer
    init(topSpace: CGFloat = .zero, bottomSpace: CGFloat = .zero) {
        self.topSpace = topSpace
        self.bottomSpace = bottomSpace
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Setup the view with a border radius of 1
    override func setupView() {
        super.setupView()

        divider.backgroundColor = .dark20
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(divider)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        divider.autoSetDimension(.height, toSize: 1)
        
        divider.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: topSpace, left: .zero, bottom: bottomSpace, right: .zero))
    }
}
