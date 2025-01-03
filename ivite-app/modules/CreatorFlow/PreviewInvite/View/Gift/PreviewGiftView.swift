//
//  PreviewGiftView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/12/2024.
//

import UIKit

protocol PreviewGiftViewDelegate: AnyObject {
    func previewGiftViewDidTapLinkButton(_ gift: Gift)
    func previewGiftViewDidTapBringButton(_ gift: Gift)
}

final class PreviewGiftView: BaseView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let linkButton = UIButton()
    private let bottomViewStackView = UIStackView()
    private let gifterView = GifterView()
    private let bringButton = UIButton(configuration: .primary(title: "I'll bring it!"))
    
    var gift: Gift?
    
    weak var delegate: PreviewGiftViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        layer.backgroundColor = UIColor.dark10.cgColor
        layer.cornerRadius = 18
        
        imageView.layer.cornerRadius = 6
        
        titleLabel.font = .interFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .secondary1
        
        linkButton.setImage(.link, for: .normal)
        linkButton.tintColor = .dark30
        
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        
        bringButton.addTarget(self, action: #selector(bringButtonTapped), for: .touchUpInside)
    }
    
    
    override func addSubviews() {
        super.addSubviews()
        
        bottomViewStackView.addArrangedSubview(bringButton)
        bottomViewStackView.addArrangedSubview(gifterView)
        
        bringButton.autoSetDimension(.height, toSize: 44)
        [
            imageView,
            titleLabel,
            linkButton,
            bottomViewStackView
        ].forEach { addSubview($0) }
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        imageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        imageView.autoMatch(.height, to: .width, of: imageView, withMultiplier: 190/263)
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 16)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        titleLabel.autoPinEdge(.trailing, to: .leading, of: linkButton, withOffset: -16, relation: .greaterThanOrEqual)
        
        linkButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        linkButton.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)
        
        bottomViewStackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        bottomViewStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .top)
    }
    
    public func configure(with gift: Gift,
                          isOwnedByCurrentUser: Bool,
                          gifter: Guest?,
                          previewMode: Bool) {
        self.gift = gift
        imageView.sd_setImage(with: gift.imageURL, placeholderImage: .giftBoxWithABow2)
        imageView.contentMode = gift.imageURL == nil ? .center : .scaleAspectFit
        
        titleLabel.text = gift.name
        linkButton.isHidden = gift.link == nil
        
        if previewMode {
            let buttonTitle = gift.gifterEmail == nil ? "I'll bring it" : "Gift Claimed"
            
            bringButton.IVsetEnabled(gift.gifterEmail == nil, title: buttonTitle)
            bringButton.isHidden = false
            gifterView.isHidden = true
        } else {
            bringButton.isHidden = true
            gifterView.isHidden = false
            
            let gifterName = gifter?.name            
            gifterView.configure(with: gifterName)
        }
    }
    
    @objc private func bringButtonTapped(_ sender: UIButton) {
        guard let gift else { return }
        delegate?.previewGiftViewDidTapBringButton(gift)
    }
    
    @objc private func linkButtonTapped(_ sender: UIButton) {
        guard let gift else { return }
        delegate?.previewGiftViewDidTapLinkButton(gift)
    }
}

