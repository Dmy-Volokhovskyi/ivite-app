//
//  GuestCell.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 10/11/2024.
//

import UIKit

final class GuestCell: BaseTableViewCell {
    private let cellBackgroundView = UIView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let menuButton = UIButton(configuration: .image(image: .menu))
    
    private var guest: Guest?
    
    override func setupCell() {
        super.setupCell()
        
        cellBackgroundView.backgroundColor = .guestBackground
        cellBackgroundView.layer.cornerRadius = 8
        
        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .secondary1
        
        emailLabel.font = .interFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = .dark30
    }
    
    override func addCellSubviews() {
        super.addCellSubviews()
        
        contentView.addSubview(cellBackgroundView)
        
        cellBackgroundView.addSubview(nameLabel)
        cellBackgroundView.addSubview(emailLabel)
        cellBackgroundView.addSubview(menuButton)
    }
    
    override func constrainCellSubviews() {
        super.constrainCellSubviews()
        
        cellBackgroundView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: .zero, bottom: .zero, right: .zero))
        
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        emailLabel.autoPinEdge(.top, to: .bottom, of: nameLabel)
        emailLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        emailLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        menuButton.autoPinEdge(.leading, to: .trailing, of: nameLabel)
        menuButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        menuButton.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    public func configure(with guest: Guest) {
        nameLabel.text = guest.name
        emailLabel.text = guest.email
    }
}
