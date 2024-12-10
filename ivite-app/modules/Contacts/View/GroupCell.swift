//
//  GroupCell.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 28/11/2024.
//

import UIKit

final class GroupCell: BaseTableViewCell {
    private let background = UIView()
    private let credentialsStackView = UIStackView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let selectedImageWrapperView = UIView()
    private let selectedImageView = UIImageView()
    
    var isAdded: Bool = false
    
    override func setupCell() {
        super.setupCell()
        
        credentialsStackView.axis = .vertical
        
        nameLabel.textColor = .secondary1
        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        
        emailLabel.textColor = .dark30
        emailLabel.font = .interFont(ofSize: 16, weight: .regular)
        
        selectedImageWrapperView.layer.cornerRadius = 4
        
        background.backgroundColor = .guestBackground
        background.layer.cornerRadius = 8
    }
    
    override func addCellSubviews() {
        super.addCellSubviews()
        
        credentialsStackView.addArrangedSubview(nameLabel)
        credentialsStackView.addArrangedSubview(emailLabel)
        
        background.addSubview(credentialsStackView)
        background.addSubview(selectedImageWrapperView)
        
        selectedImageWrapperView.addSubview(selectedImageView)
        
        contentView.addSubview(background)
    }
    
    override func constrainCellSubviews() {
        super.constrainCellSubviews()
        
        background.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: .zero, bottom: 8, right: .zero))
        
    
        credentialsStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .trailing)
        credentialsStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        credentialsStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        selectedImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        selectedImageWrapperView.autoPinEdge(.leading, to: .trailing, of: credentialsStackView, withOffset: 24)
        selectedImageWrapperView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        selectedImageWrapperView.autoAlignAxis(.horizontal, toSameAxisOf: credentialsStackView)
        
        selectedImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        selectedImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func configure(with contactCardModel: ContactCardModel, isSelected: Bool) {
        nameLabel.text = contactCardModel.name
        emailLabel.text = contactCardModel.email
        isAdded = isSelected
        selectedImageView.image = isSelected ? .group1 : .checkBox
        selectedImageWrapperView.backgroundColor = isSelected ? .accent : .clear 
    }
}
