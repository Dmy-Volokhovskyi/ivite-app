//
//  ListHeaderView.swift
//  ivite-app
//
//  Created by GoApps Developer on 05/09/2024.
//

import UIKit

protocol ListHeaderViewDelegate: AnyObject {
    func didTapFilterButton()
}

final class ListHeaderView: BaseView {
    private let titleLabel = UILabel()
    private let filterButton = UIButton(configuration: .image(image: .filter))
    private let actionButton: UIButton
    
    weak var deeleagate: ListHeaderViewDelegate?
    
    init(actionButton: UIButton, title: String) {
        self.actionButton = actionButton
        super.init()
        
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        titleLabel.font = .interFont(ofSize: 24, weight: .semiBold)
        titleLabel.textColor = .secondary1
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            titleLabel,
            filterButton,
            actionButton
        ].forEach({ addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        filterButton.setContentHuggingPriority(.init(999), for: .horizontal)
        filterButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        actionButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .leading)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: filterButton)
        
        filterButton.autoPinEdge(toSuperviewEdge: .top)
        filterButton.autoPinEdge(toSuperviewEdge: .bottom)
        filterButton.autoPinEdge(.leading, to: .trailing, of: titleLabel ,withOffset: 12)
        
        actionButton.autoPinEdge(.leading, to: .trailing, of: filterButton, withOffset: 12)
        actionButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
    }
    
    public func upateSearchButton(_ filter: FilterType) {
        filterButton.setImage(filter.image, for: .normal)
    }
    
    @objc private func filterButtonTapped() {
        deeleagate?.didTapFilterButton()
    }
}
