//
//  OrderHistoryCell.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 06/01/2025.
//

import UIKit

final class OrderHistoryCell: BaseTableViewCell {
    private let background = UIView()
    private let productView = KeyValueView()
    private let dateView = KeyValueView()
    private let priceView = KeyValueView()
    private let statusView = KeyValueView()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Setup
    override func setupCell() {
        super.setupCell()
        
        contentView.addSubview(background)
        
        background.addSubview(stackView)
        
        contentView.backgroundColor = .dark10
        backgroundView?.backgroundColor = .dark10
        
        background.backgroundColor = .white
        background.layer.cornerRadius = 5
        background.clipsToBounds = true
        
        stackView.addArrangedSubview(productView)
        stackView.addArrangedSubview(dateView)
        stackView.addArrangedSubview(priceView)
        stackView.addArrangedSubview(statusView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        background.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: .zero, left: .zero, bottom: 12, right: .zero))
        
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 16, bottom: 18, right: 16))
    }
    
    // MARK: - Configuration
    func configure(with item: OrderHistoryItem) {
        productView.configure(key: "Product:", value: item.product)
        dateView.configure(key: "Date:", value: item.date)
        priceView.configure(key: "Price:", value: item.price)
        statusView.configure(key: "Status:",
                             value: item.status,
                             valueColor: item.isSuccess ? .systemGreen : .systemRed)
    }
}

