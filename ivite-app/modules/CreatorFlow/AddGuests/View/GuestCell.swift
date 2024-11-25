//
//  GuestCell.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 10/11/2024.
//

import UIKit

protocol GuestCellDelegate: AnyObject {
    func didTouchMenu(for cell: BaseTableViewCell)
}

final class GuestCell: BaseTableViewCell {
    private let cellBackgroundView = UIView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let menuButton = UIButton(configuration: .image(image: .menu.withRenderingMode(.alwaysTemplate).withTintColor(.dark30)))
    
    private var guest: Guest?
    
    weak var delegate: GuestCellDelegate?
    
    override func setupCell() {
        super.setupCell()
        
        cellBackgroundView.backgroundColor = .guestBackground
        cellBackgroundView.layer.cornerRadius = 8
        
        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .secondary1
        
        emailLabel.font = .interFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = .dark30
        
        menuButton.addTarget(self, action: #selector(handleMenuButtonTapped), for: .touchUpInside)
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
    
    @objc private func handleMenuButtonTapped(_ sender: UIButton) {
        delegate?.didTouchMenu(for: self)
    }
}
