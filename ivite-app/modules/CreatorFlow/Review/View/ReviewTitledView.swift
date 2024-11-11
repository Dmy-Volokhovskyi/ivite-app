//
//  ReviewTitledView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 10/11/2024.
//

import UIKit

final class ReviewTitledView: BaseView {
    private let titleLabel = UILabel()
    private let contentView = UIView()
    private let subtitleLabel = UILabel()
    
    override func setupView() {
        super.setupView()
        
        titleLabel.textColor = .secondary1
        titleLabel.font = .interFont(ofSize: 16, weight: .bold)
        
        subtitleLabel.textColor = .secondary1
        subtitleLabel.font = .interFont(ofSize: 16, weight: .regular)
        subtitleLabel.numberOfLines = 0
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(titleLabel)
        addSubview(contentView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        titleLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        contentView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 8)
        contentView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    public func configure(title: String, subtitle: String?, content: UIView?) {
        if let content {
            contentView.addSubview(content)
            content.autoPinEdgesToSuperviewEdges(with: .zero)
        } else if let subtitle {
            subtitleLabel.text = subtitle
            contentView.addSubview(subtitleLabel)
            subtitleLabel.autoPinEdgesToSuperviewEdges(with: .zero)
        }
        titleLabel.text = title
    }
}
