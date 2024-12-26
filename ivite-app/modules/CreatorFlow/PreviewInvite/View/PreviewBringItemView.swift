//
//  PreviewBringItemView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/12/2024.
//

import UIKit

final class PreviewBringItemView: BaseView {
    let titleLabel = UILabel()
    let countLabel = UILabel()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1)

        titleLabel.textColor = .secondary1
        titleLabel.font = .interFont(ofSize: 16, weight: .regular)
        
        countLabel.textColor = .dark30
        countLabel.font = .interFont(ofSize: 14, weight: .bold)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(titleLabel)
        addSubview(countLabel)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        titleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 11, left: 20, bottom: 11, right: 20), excludingEdge: .trailing)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        countLabel.autoPinEdge(.leading, to: .trailing, of: titleLabel, withOffset: 10)
        countLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 11, left: 20, bottom: 11, right: 20), excludingEdge: .leading)
        
        countLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    public func configure(bringListItem: BringListItem) {
        titleLabel.text = bringListItem.name
        countLabel.text = bringListItem.count.flatMap { "\($0)x" } ?? ""
    }
}
