//
//  PreviewGuestView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/12/2024.
//

import UIKit

final class PreviewGuestView: BaseView {
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let guestStatusLabel = UILabel()
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 7
        backgroundColor = .dark10
        
        stackView.distribution = .fillEqually
        
        nameLabel.font = .interFont(ofSize: 16, weight: .semiBold)
        nameLabel.textColor = .secondary1
        
        guestStatusLabel.font = .interFont(ofSize: 16, weight: .regular)
        guestStatusLabel.textColor = .dark30
        guestStatusLabel.textAlignment = .right
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(guestStatusLabel)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    public func configure(guest: Guest, isPreview: Bool) {
        nameLabel.text = guest.name
        guestStatusLabel.text = guest.status.stringValue
        guestStatusLabel.isHidden = isPreview
    }
}
