//
//  ContactCardCell.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//

import UIKit

protocol ContactCardCellDelegate: AnyObject {
    func didTouchMenu(for cell: BaseTableViewCell)
}

final class ContactCardCell: BaseTableViewCell {
    private let headerLabel = UILabel()
    private let textStackView = UIStackView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let birthDateLabel = UILabel()
    private let contactGroupLabel = UILabel()
    
    private let menuButton = UIButton(configuration: .image(image: .menu.withRenderingMode(.alwaysTemplate)))
    
    weak var delegate: ContactCardCellDelegate?
    
    override func setupCell() {
        super.setupCell()
        
        
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 5
        
        headerLabel.text = "Contact info:"
        headerLabel.font = .interFont(ofSize: 14, weight: .semiBold)
        headerLabel.textColor = .dark30
        
        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .secondary1
   
        emailLabel.font = .interFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = .secondary1
        
        birthDateLabel.font = .interFont(ofSize: 16, weight: .regular)
        birthDateLabel.textColor = .secondary1
        
        contactGroupLabel.font = .interFont(ofSize: 16, weight: .regular)
        contactGroupLabel.textColor = .dark30
        
        menuButton.addTarget(self, action: #selector(openMenuDidTouch), for: .touchUpInside)
        
        contentView.backgroundColor = .dark10.withAlphaComponent(0.7)
        contentView.layer.cornerRadius = 16
    }
    
    override func addCellSubviews() {
        super.addCellSubviews()
        
        [
            headerLabel,
            textStackView,
 
            menuButton
        ].forEach(contentView.addSubview)
        
        [
            nameLabel,
            emailLabel,
            birthDateLabel,
            contactGroupLabel
        ].forEach(textStackView.addArrangedSubview)
    }
    
    override func constrainCellSubviews() {
        super.constrainCellSubviews()
        
        headerLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        headerLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        
        textStackView.autoPinEdge(.top, to: .bottom, of: headerLabel, withOffset: 16)
        textStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        textStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16, relation: .greaterThanOrEqual)
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        menuButton.autoPinEdge(.leading, to: .trailing, of: textStackView, withOffset: 20)
        menuButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        menuButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        menuButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func configure(with contactCardModel: ContactCardModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, yyyy"
        
        nameLabel.text = contactCardModel.name
        emailLabel.text = contactCardModel.email
        birthDateLabel.text = dateFormatter.string(from: contactCardModel.date)
        
//        contactGroupLabel.text = contactCardModel.groups.map{ $0.name }.joined(separator: ", ")
    }
    
    @objc private func openMenuDidTouch(_ sender: UIButton) {
        delegate?.didTouchMenu(for: self)
    }
}
