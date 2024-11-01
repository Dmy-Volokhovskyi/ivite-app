//
//  MenuItemView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 28/10/2024.
//


import UIKit

final class MenuItemView: BaseControll {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let chevronRightImageView = UIImageView(image: .chevroneRight)
    private var menuItem: ProfileMenuItem
    
    // Define a closure to handle item selection
    var didTapItem: ((ProfileMenuItem) -> Void)?

    init(menuItem: ProfileMenuItem) {
        self.menuItem = menuItem
        super.init(frame: .zero)
        
        titleLabel.text = menuItem.title
        iconImageView.image = menuItem.icon
        
        // Add tap gesture
        self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        self.isUserInteractionEnabled = true
    }

    @objc private func handleTap() {
        // Trigger the closure when tapped
        didTapItem?(menuItem)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .secondary1
        titleLabel.textColor = .secondary1
        titleLabel.font = .interFont(ofSize: 16)
        backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [iconImageView, titleLabel, chevronRightImageView].forEach(addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()

        iconImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        iconImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        iconImageView.autoSetDimensions(to: CGSize(width: 24, height: 24))

        titleLabel.autoPinEdge(.leading, to: .trailing, of: iconImageView, withOffset: 16)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        titleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        chevronRightImageView.autoPinEdge(.leading, to: .trailing, of: titleLabel, withOffset: 8)
        chevronRightImageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        chevronRightImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        chevronRightImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        chevronRightImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        autoSetDimension(.height, toSize: 60)
    }
}

