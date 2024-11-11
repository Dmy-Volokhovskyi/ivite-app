//
//  PaymentOptionCell.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//


import UIKit
import Reusable
import PureLayout

class PaymentOptionCell: BaseTableViewCell {
    private let contentBackgroundView = UIView()
    private let radioButton = RadioButton()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let currencyLabel = UILabel()
    private let priceLabel = UILabel()
    private let billingLabel = UILabel()
    private let stackView = UIStackView()
    
    override func setupCell() {
        super.setupCell()
        
        contentView.backgroundColor = .paymentBackground
        
        titleLabel.font = .interFont(ofSize: 18, weight: .semiBold)
        titleLabel.textColor = .secondary1
        
        detailLabel.font = .interFont(ofSize: 14, weight: .regular)
        detailLabel.textColor = .dark30
        
        priceLabel.font = .interFont(ofSize: 24, weight: .semiBold)
        priceLabel.textColor = .secondary1
        
        currencyLabel.text = "$"
        currencyLabel.font = .interFont(ofSize: 14, weight: .semiBold)
        currencyLabel.textColor = .dark30
        
        billingLabel.font = .interFont(ofSize: 14, weight: .semiBold)
        billingLabel.textColor = .dark30
        
        contentBackgroundView.backgroundColor = .white
        contentBackgroundView.layer.cornerRadius = 10
        
        stackView.axis = .vertical
        stackView.spacing = 4
    }
    
    override func addCellSubviews() {
        super.addCellSubviews()
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        
        contentView.addSubview(contentBackgroundView)
        
        [
            radioButton,
            stackView,
            priceLabel,
            currencyLabel,
            billingLabel,
            currencyLabel
        ].forEach(contentBackgroundView.addSubview)
    }
    
    override func constrainCellSubviews() {
        super.constrainCellSubviews()
        
        contentBackgroundView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: .zero, bottom: .zero, right: .zero))
        
        radioButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        radioButton.autoSetDimensions(to: CGSize(width: 24, height: 24))
        
        radioButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        stackView.autoPinEdge(.leading, to: .trailing, of: radioButton, withOffset: 12)
        stackView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        stackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        currencyLabel.autoPinEdge(.leading, to: .trailing, of: stackView)
        currencyLabel.autoPinEdge(.top, to: .top, of: priceLabel, withOffset: 4)
        currencyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
       
        priceLabel.autoPinEdge(.leading, to: .trailing, of: currencyLabel)
        priceLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        billingLabel.autoPinEdge(.leading, to: .trailing, of: priceLabel)
        billingLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        billingLabel.autoAlignAxis(.firstBaseline, toSameAxisOf: priceLabel)
        billingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        detailLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    func configure(paymentOption: PaymentOption, isSelected: Bool) {
        titleLabel.text = paymentOption.title
        detailLabel.text = "(\(paymentOption.detail))"
        priceLabel.text = String(paymentOption.price)
        billingLabel.text = paymentOption.billingCycle.cycleString
        
        radioButton.updateImage(isSelected: isSelected)
    }
}
