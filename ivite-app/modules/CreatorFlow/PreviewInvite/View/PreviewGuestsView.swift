//
//  PreviewGuestsView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/12/2024.
//

import UIKit

protocol PreviewGuestsViewDelegate: AnyObject {
    func seeAllGuestsButtonTapped()
}

final class PreviewGuestsView: BaseView {
    private let whoIsCommingLabel = UILabel()
    private let seeAllGuestsButton = UIButton()
    private let guestsStackView = UIStackView()
    
    weak var delegate: PreviewGuestsViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        layer.cornerRadius = 10
        
        whoIsCommingLabel.text = "Who's coming"
        whoIsCommingLabel.font = .interFont(ofSize: 24, weight: .semiBold)
        whoIsCommingLabel.textColor = .secondary1
        
        seeAllGuestsButton.setTitle("See All Guests", for: .normal)
        seeAllGuestsButton.setTitleColor(.accent, for: .normal)
        seeAllGuestsButton.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        seeAllGuestsButton.addTarget(self, action: #selector(seeAllGuestsTapped), for: .touchUpInside)

        guestsStackView.axis = .vertical
        guestsStackView.spacing = 12
        guestsStackView.distribution = .fillEqually
        guestsStackView.alignment = .fill
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            whoIsCommingLabel,
            seeAllGuestsButton,
            guestsStackView
        ].forEach({ addSubview($0) })
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
 
        whoIsCommingLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 24)
        whoIsCommingLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)

        seeAllGuestsButton.autoAlignAxis(.horizontal, toSameAxisOf: whoIsCommingLabel)
        seeAllGuestsButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
 
        guestsStackView.autoPinEdge(.top, to: .bottom, of: whoIsCommingLabel, withOffset: 16)
        guestsStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        guestsStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        guestsStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 24, relation: .greaterThanOrEqual)
    }
    
    public func configure(with guests: [Guest], isPreview: Bool) {
        guestsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let limitedGuests = guests.prefix(8)
        let hasMoreGuests = guests.count > 8

        limitedGuests.forEach { guest in
            let guestView = PreviewGuestView()
            guestView.configure(guest: guest, isPreview: isPreview)
            guestsStackView.addArrangedSubview(guestView)
        }

        seeAllGuestsButton.isHidden = !hasMoreGuests
    }
    
    @objc public func seeAllGuestsTapped(_ sender: UIButton) {
        delegate?.seeAllGuestsButtonTapped()
    }
}
