//
//  TextEditMenuButton.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 24/09/2024.
//

import UIKit
import PureLayout

class TextEditMenuButton: BaseControll {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    private var menuItem: TextEditMenuItem

    // Initialize with a menu item
    init(menuItem: TextEditMenuItem) {
        self.menuItem = menuItem
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Override the setupView to configure initial settings
    override func setupView() {
        // Set up imageView properties
        imageView.image = menuItem.image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        
        // Set up titleLabel properties
        titleLabel.text = menuItem.title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
    }

    // Override addSubviews to add the image and label
    override func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }

    // Override constrainSubviews to define layout constraints
    override func constrainSubviews() {
        // Constraints for the imageView
        imageView.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        imageView.autoAlignAxis(toSuperviewAxis: .vertical)
        imageView.autoSetDimensions(to: CGSize(width: 30, height: 30)) // Customize image size

        // Constraints for the titleLabel
        titleLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 8)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 4)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 4)
        titleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
    }
}

