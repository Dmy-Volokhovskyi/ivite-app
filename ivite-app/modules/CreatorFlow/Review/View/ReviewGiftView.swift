//
//  ReviewGiftView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

final class ReviewGiftView: BaseView {
    private let stackView = UIStackView()
    private let giftTitle = UILabel()
    private let giftLinkImage = UIImageView(image: .link)
    private let giftLinkLabel = UILabel()
    private let giftImageView = UIImageView()
    
    override func setupView() {
        super.setupView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        giftTitle.textColor = .secondary1
        giftTitle.font = .interFont(ofSize: 16, weight: .regular)

        giftLinkLabel.textColor = .secondary1
        giftLinkLabel.font = .interFont(ofSize: 16, weight: .regular)

        giftImageView.contentMode = .scaleAspectFit
        giftImageView.layer.cornerRadius = 10
    }
    
    override func addSubviews() {
        super.addSubviews()

        addSubview(stackView)

        stackView.addArrangedSubview(giftTitle)

        let linkStack = UIStackView(arrangedSubviews: [giftLinkImage, giftLinkLabel])
        linkStack.axis = .horizontal
        linkStack.spacing = 8
        stackView.addArrangedSubview(linkStack)

        stackView.addArrangedSubview(giftImageView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()

        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: .zero, left: .zero, bottom: 16, right: .zero))
        
        giftImageView.autoMatch(.width, to: .width, of: self, withOffset: -30, relation: .greaterThanOrEqual)
        giftImageView.autoMatch(.height, to: .width, of: giftImageView, withMultiplier: 189/233)
    
        giftLinkImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        giftLinkImage.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    public func configure(gift: Gift) {
        giftTitle.text = gift.name
        giftTitle.isHidden = gift.name.isEmpty

        if let link = gift.link, !link.isEmpty {
            giftLinkLabel.text = link
            giftLinkImage.isHidden = false
            giftLinkLabel.isHidden = false
        } else {
            giftLinkImage.isHidden = true
            giftLinkLabel.isHidden = true
        }

        if let imageData = gift.image, let image = UIImage(data: imageData) {
            giftImageView.image = image
            giftImageView.isHidden = false
        } else {
            giftImageView.isHidden = true
        }
    }
}

