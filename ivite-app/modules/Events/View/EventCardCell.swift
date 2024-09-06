//
//  EventCardCell.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//

import UIKit

protocol EventCardCellDelegate: AnyObject {
    func didTouchMenu(for cell: BaseTableViewCell)
}

final class EventCardCell: BaseTableViewCell {
    private let cardImageView = UIImageView()
    private let textStackView = UIStackView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusLabel = UILabel()
    private let menuButton = UIButton(configuration: .image(image: .menu, color: .primaryLight20))
    
    weak var delegate: EventCardCellDelegate?
    
    override func setupCell() {
        super.setupCell()
        
        cardImageView.layer.cornerRadius = 5
        cardImageView.clipsToBounds = true
        
        textStackView.axis = .vertical
        textStackView.spacing = 8
        
        titleLabel.font = .interFont(ofSize: 18, weight: .semiBold)
        titleLabel.textColor = .secondary1
        titleLabel.numberOfLines = 0
        
        dateLabel.font = .interFont(ofSize: 16, weight: .regular)
        dateLabel.textColor = .secondary1
        
        statusLabel.font = .interFont(ofSize: 14, weight: .semiBold)
        
        menuButton.addTarget(self, action: #selector(openMenuDidTouch), for: .touchUpInside)
        
        contentView.backgroundColor = .dark10.withAlphaComponent(0.7)
        contentView.layer.cornerRadius = 16
    }
    
    override func addCellSubviews() {
        super.addCellSubviews()
        
        [
            cardImageView,
            textStackView,
            menuButton
        ].forEach(contentView.addSubview)
        
        [
            titleLabel,
            dateLabel,
            statusLabel
        ].forEach(textStackView.addArrangedSubview)
    }
    
    override func constrainCellSubviews() {
        super.constrainCellSubviews()
        
        cardImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        cardImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        cardImageView.autoSetDimension(.width, toSize: 64)
        cardImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16, relation: .greaterThanOrEqual)
        cardImageView.autoMatch(.height, to: .width, of: cardImageView, withMultiplier: 88/64)
        cardImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        textStackView.autoPinEdge(.leading, to: .trailing, of: cardImageView, withOffset: 20)
        textStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        textStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16, relation: .greaterThanOrEqual)
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        menuButton.autoPinEdge(.leading, to: .trailing, of: textStackView, withOffset: 20)
        menuButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        menuButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        menuButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func configure(with eventCardModel: EventCardModel) {
        cardImageView.image = UIImage(named: eventCardModel.imageName)
        
        titleLabel.text = eventCardModel.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, yyyy"
        
        dateLabel.text = dateFormatter.string(from: eventCardModel.date)
        
        statusLabel.text = eventCardModel.status
        statusLabel.textColor = eventCardModel.statusColor
    }
    
    @objc private func openMenuDidTouch(_ sender: UIButton) {
        delegate?.didTouchMenu(for: self)
    }
}
