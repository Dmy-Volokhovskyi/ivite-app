//
//  ReviewGuestView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

final class ReviewGuestView: BaseView {
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .guestBackground
        layer.cornerRadius = 8
        
        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .secondary1
        
        emailLabel.font = .interFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = .dark30
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            nameLabel,
            emailLabel
        ].forEach(addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        emailLabel.autoPinEdge(.top, to: .bottom, of: nameLabel)
        emailLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        emailLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
    
    public func configure(with guest: Guest) {
        nameLabel.text = guest.name
        emailLabel.text = guest.email
    }
}


