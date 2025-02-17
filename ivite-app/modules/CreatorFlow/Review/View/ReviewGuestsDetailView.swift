//
//  ReviewGuestsView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

final class ReviewGuestsDetailView: BaseView {
    private let editButton = UIButton(configuration: .plain())
    private let guestsHeaderView = IVHeaderLabel(text: "Guests")
    private let guestsStackView = UIStackView()
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 10
        backgroundColor = .white
        
        editButton.setImage(.editOrange, for: .normal)
        
        guestsStackView.axis = .vertical
        guestsStackView.spacing = 8
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            editButton,
            guestsHeaderView,
            guestsStackView
        ].forEach(addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        guestsHeaderView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        guestsHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        editButton.autoPinEdge(.leading, to: .trailing, of: guestsHeaderView, withOffset: 16)
        editButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        editButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        editButton.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        guestsStackView.autoPinEdge(.top, to: .bottom, of: guestsHeaderView, withOffset: 16)
        guestsStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .top)
    }
    
    public func configre(with guests: [Guest]) {
        guestsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        guests.forEach { guest in
            let guestView = ReviewGuestView()
            guestView.configure(with: guest)
            guestsStackView.addArrangedSubview(guestView)
        }
    }
}
