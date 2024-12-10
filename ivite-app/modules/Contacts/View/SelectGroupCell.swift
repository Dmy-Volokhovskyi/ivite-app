//
//  SelectGroupCell.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 09/12/2024.
//

import UIKit

protocol SelectGroupCellDelegate: AnyObject {
    func selectGroupCellDidTapEdit(_ cell: SelectGroupCell)
    func selectGroupCellDidTapDelete(_ cell: SelectGroupCell)
}

final class SelectGroupCell: BaseTableViewCell {
    private let nameLabel = UILabel()
    private let selectedImageWrapperView = UIView()
    private let selectedImageView = UIImageView()
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    
    weak var delegate: SelectGroupCellDelegate?
    var isAdded: Bool = false
    
    override func setupCell() {
        super.setupCell()
        
        nameLabel.textColor = .secondary1
        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        
        selectedImageWrapperView.layer.cornerRadius = 4
        
        contentView.backgroundColor = .dark10
        contentView.layer.cornerRadius = 8
        
        // Configure buttons
        editButton.setImage(.edit.withTintColor(.dark30), for: .normal)
        deleteButton.setImage(.delete.withTintColor(.dark30), for: .normal)
        
        editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }
    
    override func addCellSubviews() {
        super.addCellSubviews()
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(selectedImageWrapperView)
        selectedImageWrapperView.addSubview(selectedImageView)
        contentView.addSubview(editButton)
        contentView.addSubview(deleteButton)
    }
    
    override func constrainCellSubviews() {
        super.constrainCellSubviews()

        nameLabel.autoPinEdge(.leading, to: .trailing, of: selectedImageWrapperView, withOffset: 10)
        nameLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        selectedImageWrapperView.autoSetDimensions(to: CGSize(width: 24, height: 24))
        selectedImageWrapperView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), excludingEdge: .trailing)
        
        selectedImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        deleteButton.autoSetDimensions(to: CGSize(width: 24, height: 24))
        deleteButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        deleteButton.autoAlignAxis(.horizontal, toSameAxisOf: nameLabel)
        
        editButton.autoSetDimensions(to: CGSize(width: 24, height: 24))
        editButton.autoPinEdge(.trailing, to: .leading, of: deleteButton, withOffset: -10)
        editButton.autoAlignAxis(.horizontal, toSameAxisOf: nameLabel)
    }
    
    func configure(with groupModel: ContactGroup, isSelected: Bool) {
        nameLabel.text = groupModel.name
        isAdded = isSelected
        selectedImageView.image = isSelected ? .group1 : .checkBox
        selectedImageWrapperView.backgroundColor = isSelected ? .accent : .clear
    }
    
    @objc private func didTapEdit() {
        delegate?.selectGroupCellDidTapEdit(self)
    }
    
    @objc private func didTapDelete() {
        delegate?.selectGroupCellDidTapDelete(self)
    }
}
