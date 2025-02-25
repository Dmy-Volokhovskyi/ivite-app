//
//  PastListCell.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 25/02/2025.
//

import UIKit

protocol PastListCellDelegate: AnyObject {
    func didTouch(cell: BaseTableViewCell)
}

final class PastListCell: BaseTableViewCell {
    private let cellBackgroundView = UIControl()
    private let coverImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let selectedImageWrapperView = UIView()
    private let selectedImageView = UIImageView()
    
    weak var delegate: PastListCellDelegate?
    
    override func setupCell() {
        super.setupCell()
        
        cellBackgroundView.backgroundColor = .guestBackground
        cellBackgroundView.layer.cornerRadius = 8
        
        nameLabel.font = .interFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .secondary1
        
        emailLabel.font = .interFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = .dark30
        coverImageView.layer.cornerRadius = 4
        
        selectedImageWrapperView.layer.cornerRadius = 4
        
        cellBackgroundView.addTarget(self, action: #selector(selectDidTouch), for: .touchUpInside)
    }
    
    override func addCellSubviews() {
        super.addCellSubviews()
        
        contentView.addSubview(cellBackgroundView)
        
        cellBackgroundView.addSubview(coverImageView)
        cellBackgroundView.addSubview(nameLabel)
        cellBackgroundView.addSubview(emailLabel)
        cellBackgroundView.addSubview(selectedImageWrapperView)
        selectedImageWrapperView.addSubview(selectedImageView)
    }
    
    override func constrainCellSubviews() {
        super.constrainCellSubviews()
        
        cellBackgroundView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: .zero, bottom: .zero, right: .zero))
        
        coverImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .trailing
        )
        
        coverImageView.autoSetDimensions(to: CGSize(width: 36, height: 52))
        
        nameLabel.autoPinEdge(.leading, to: .trailing, of: coverImageView, withOffset: 16)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        emailLabel.autoPinEdge(.top, to: .bottom, of: nameLabel)
        emailLabel.autoPinEdge(.leading, to: .trailing, of: coverImageView, withOffset: 16)
        emailLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        selectedImageWrapperView.autoPinEdge(.leading, to: .trailing, of: nameLabel)
        selectedImageWrapperView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        selectedImageWrapperView.autoAlignAxis(toSuperviewAxis: .horizontal)
        selectedImageWrapperView.autoSetDimensions(to: CGSize(width: 24, height: 24))
        selectedImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
    }
    
    func configure(with event: Event, isSelected: Bool) {
        nameLabel.text = event.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, yyyy"
        
        emailLabel.text = dateFormatter.string(from: event.date ?? Date())
        
        coverImageView.sd_setImage(with: URL(string: event.canvasImageURL ?? ""))
        
        selectedImageView.image = isSelected ? .group1 : .checkBox
        selectedImageWrapperView.backgroundColor = isSelected ? .accent : .clear
    }
    
    @objc private func selectDidTouch(_ sender: UIButton) {
        delegate?.didTouch(cell: self)
    }
}
