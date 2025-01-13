//
//  ContactCardCellDelegate.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 09/01/2025.
//


import UIKit

protocol ContactCardCellDelegate1: AnyObject {
    func contactCardCell(_ cell: ContactCardCell1, didToggleCheckbox isSelected: Bool)
}

final class ContactCardCell1: BaseTableViewCell {
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let checkboxWrapperView = UIView()
    private let checkboxImageView = UIImageView()

    weak var delegate: ContactCardCellDelegate1?
    private var isChecked: Bool = false

    // MARK: - Setup Cell
    override func setupCell() {
        super.setupCell()

        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .secondary1

        emailLabel.font = .interFont(ofSize: 14, weight: .regular)
        emailLabel.textColor = .dark30

//        checkboxWrapperView.layer.borderWidth = 1
        checkboxWrapperView.layer.borderColor = UIColor.dark30.cgColor
        checkboxWrapperView.backgroundColor = .clear
        checkboxWrapperView.isUserInteractionEnabled = true

        checkboxImageView.contentMode = .scaleAspectFit
        checkboxImageView.image = .checkBox // Default unchecked image

        // Add tap gesture to checkbox
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
        checkboxWrapperView.addGestureRecognizer(tapGesture)
    }

    override func addCellSubviews() {
        super.addCellSubviews()

        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(checkboxWrapperView)
        checkboxWrapperView.addSubview(checkboxImageView)
    }

    override func constrainCellSubviews() {
        super.constrainCellSubviews()

        // Constraints for checkbox
        checkboxWrapperView.autoSetDimensions(to: CGSize(width: 24, height: 24))
        checkboxWrapperView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        checkboxWrapperView.autoAlignAxis(toSuperviewAxis: .horizontal)

        checkboxImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))

        // Constraints for nameLabel
        nameLabel.autoPinEdge(.leading, to: .trailing, of: checkboxWrapperView, withOffset: 12)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)

        // Constraints for emailLabel
        emailLabel.autoPinEdge(.leading, to: .trailing, of: checkboxWrapperView, withOffset: 12)
        emailLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 4)
        emailLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        emailLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
    }

    // MARK: - Public Configuration
    func configure(with contact: ContactCardModel, isSelected: Bool) {
        nameLabel.text = contact.name
        emailLabel.text = contact.email
        isChecked = isSelected
        updateCheckbox()
    }

    // MARK: - Private Methods
    @objc private func toggleCheckbox() {
        isChecked.toggle()
        updateCheckbox()
        delegate?.contactCardCell(self, didToggleCheckbox: isChecked)
    }

    private func updateCheckbox() {
        checkboxImageView.image = isChecked ? .group1 : .checkBox
        checkboxWrapperView.backgroundColor = isChecked ? .accent : .clear
    }
}

protocol GuestContactCellDelegate: AnyObject {
    func contactCardCell(_ cell: GuestContactCell)
}

final class GuestContactCell: BaseTableViewCell {
    private let cellBackgroundView = UIControl()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let selectedImageWrapperView = UIView()
    private let selectedImageView = UIImageView()
    
    weak var delegate: GuestContactCellDelegate?
    
    override func setupCell() {
        super.setupCell()
        
        cellBackgroundView.backgroundColor = .guestBackground
        cellBackgroundView.layer.cornerRadius = 8
        
        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .secondary1
        
        emailLabel.font = .interFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = .dark30
        
        selectedImageWrapperView.layer.cornerRadius = 4
        
        cellBackgroundView.addTarget(self, action: #selector(selectDidTouch), for: .touchUpInside)
    }
    
    override func addCellSubviews() {
        super.addCellSubviews()
        
        contentView.addSubview(cellBackgroundView)
        
        cellBackgroundView.addSubview(nameLabel)
        cellBackgroundView.addSubview(emailLabel)
        cellBackgroundView.addSubview(selectedImageWrapperView)
        selectedImageWrapperView.addSubview(selectedImageView)
    }
    
    override func constrainCellSubviews() {
        super.constrainCellSubviews()
        
        cellBackgroundView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: .zero, bottom: .zero, right: .zero))
        
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        emailLabel.autoPinEdge(.top, to: .bottom, of: nameLabel)
        emailLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        emailLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        selectedImageWrapperView.autoPinEdge(.leading, to: .trailing, of: nameLabel)
        selectedImageWrapperView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        selectedImageWrapperView.autoAlignAxis(toSuperviewAxis: .horizontal)
        selectedImageWrapperView.autoSetDimensions(to: CGSize(width: 24, height: 24))
        selectedImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
    }
    
    func configure(with contactCardModel: ContactCardModel, isSelected: Bool) {
        nameLabel.text = contactCardModel.name
        emailLabel.text = contactCardModel.email

        selectedImageView.image = isSelected ? .group1 : .checkBox
        selectedImageWrapperView.backgroundColor = isSelected ? .accent : .clear
    }
    
    @objc private func selectDidTouch(_ sender: UIButton) {
        delegate?.contactCardCell(self)
    }
}
