//
//  ReviewGiftsDetailView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

final class ReviewGiftsDetailView: BaseView {
    private let editButton = UIButton(configuration: .plain())
    private let giftsHeaderView = IVHeaderLabel(text: "Gifts")
    private let giftsStackView = UIStackView()
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 10
        backgroundColor = .white
        
        editButton.setImage(.editOrange, for: .normal)
        
        giftsStackView.axis = .vertical
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            editButton,
            giftsHeaderView,
            giftsStackView
        ].forEach(addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        giftsHeaderView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        giftsHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        editButton.autoPinEdge(.leading, to: .trailing, of: giftsHeaderView, withOffset: 16)
        editButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        editButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        giftsStackView.autoPinEdge(.top, to: .bottom, of: giftsHeaderView, withOffset: 16)
        giftsStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .top)
    }
    
    public func configure(with model: GiftDetailsViewModel) {
        giftsStackView.subviews.forEach({ $0.removeFromSuperview() })
        model.gifts.forEach({ gift in
            let reviewGiftView = ReviewGiftView()
            reviewGiftView.configure(gift: gift)
            giftsStackView.addArrangedSubview(reviewGiftView)
            
            if gift.id != model.gifts.last?.id {
                let separatorView = DividerView(topSpace: .zero, bottomSpace: 16)
                giftsStackView.addArrangedSubview(separatorView)
            }
        })
    }
}
