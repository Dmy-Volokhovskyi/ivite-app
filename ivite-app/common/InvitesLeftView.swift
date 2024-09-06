//
//  InvitesLeftView.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//

import UIKit

final class InvitesLeftView: BaseView {
    private let invitesLeftTitleLabel = UILabel()
    private let invitesLeftCountLabel = UILabel()
    
    override func setupView() {
        super.setupView()
        
        invitesLeftTitleLabel.text = "Invites left:"
        invitesLeftTitleLabel.font = .interFont(ofSize: 16, weight: .regular)
        invitesLeftTitleLabel.textColor = .dark30
        
        invitesLeftCountLabel.font = .interFont(ofSize: 16, weight: .semiBold)
        invitesLeftCountLabel.textColor = .accent
        invitesLeftCountLabel.textAlignment = .left
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            invitesLeftTitleLabel,
            invitesLeftCountLabel
        ].forEach({ addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        invitesLeftTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        invitesLeftTitleLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)
        
        
        invitesLeftCountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        invitesLeftCountLabel.autoPinEdge(.leading, to: .trailing, of: invitesLeftTitleLabel, withOffset: 7)
        invitesLeftCountLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
    }
    
    func configure(invitesLeft: String) {
        invitesLeftCountLabel.text = invitesLeft
    }
}
