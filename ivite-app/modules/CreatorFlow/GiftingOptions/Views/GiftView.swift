//
//  GiftView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 03/11/2024.
//

import UIKit

protocol GiftViewDelegate: AnyObject {
    func didTouchMenuButton(for gift: Gift)
}

final class GiftView: BaseView {
    private let giftImage = GiftPlaceholderImage()
    private let nameContentStack = UIStackView()
    private let giftTitle = UILabel()
    private let linkStackView = UIStackView()
    private let giftLinkimage = UIImageView(image: .link)
    private let giftLinkLabel = UILabel()
    private let menuButton = UIButton(configuration: .image(image: .menu))
    
    weak var delegate: GiftViewDelegate?
    
    let gift: Gift
    
    init(gift: Gift) {
        self.gift = gift
        super.init()
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 8
        backgroundColor = .giftBackground
        
        nameContentStack.axis = .vertical
        
        giftImage.displayImage(gift.image)
        
        giftTitle.text = gift.name
        giftTitle.textColor = .secondary1
        giftTitle.font = .interFont(ofSize: 16, weight: .regular)
        
        giftLinkLabel.text = gift.link
        giftLinkLabel.textColor = .dark30
        giftLinkLabel.font = .interFont(ofSize: 14, weight: .regular)
        
        linkStackView.isHidden = (gift.link?.isEmpty == true)
        menuButton.addTarget(self, action: #selector(didTouchMenuButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            giftImage,
            nameContentStack,
            menuButton
        ].forEach({ addSubview($0) })
        
        nameContentStack.addArrangedSubview(giftTitle)
        nameContentStack.addArrangedSubview(linkStackView)
        
        linkStackView.addArrangedSubview(giftLinkimage)
        linkStackView.addArrangedSubview(giftLinkLabel)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        giftImage.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .trailing)
        giftImage.autoSetDimensions(to: CGSize(width: 48, height: 48))
        
        nameContentStack.autoPinEdge(.leading, to: .trailing, of: giftImage, withOffset: 16)
        nameContentStack.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        nameContentStack.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        nameContentStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        menuButton.autoPinEdge(.leading, to: .trailing, of: nameContentStack, withOffset: 16)
        menuButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        menuButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        menuButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    @objc private func didTouchMenuButton(_ sender: UIButton) {
        delegate?.didTouchMenuButton(for: gift)
    }
}
