//
//  AlertViewController.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 15/11/2024.
//

import UIKit

struct AlertItem {
    let title: String
    let message: String?
    let actions: [ActionItem]
}

class AlertViewController: BaseViewController {
    private let contentView = UIView()
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let stackView = UIStackView()
    private var actions: [ActionItem] = []
    
    override func setupView() {
        super.setupView()
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 8
        
        titleLabel.textColor = .secondary1
        titleLabel.font = .interFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        messageLabel.textColor = .secondary1
        messageLabel.font = .interFont(ofSize: 16, weight: .regular)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        view.backgroundColor = .clear
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.addSubview(contentView)
        
        contentView.addSubview(labelStackView)
        
        [
            titleLabel,
            messageLabel,
        ].forEach(labelStackView.addArrangedSubview)
        
        contentView.addSubview(stackView)
        
        setupStackView()
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        contentView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        labelStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), excludingEdge: .bottom)
        
        stackView.autoPinEdge(.top, to: .bottom, of: labelStackView, withOffset: 16)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), excludingEdge: .top)
    }
    
    public func setAlertItem(_ item: AlertItem) {
        titleLabel.text = item.title
        messageLabel.text = item.message
        messageLabel.isHidden = item.message?.isEmpty == false
        setActions(item.actions)
    }
    
    private func setActions(_ actions: [ActionItem]) {
        self.actions = actions
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for action in actions {
            let button = createButton(for: action)
            stackView.addArrangedSubview(button)
        }
        
        view.invalidateIntrinsicContentSize()
    }
    
    private func setupStackView() {
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
    }
    
    private func createButton(for action: ActionItem) -> UIControl {
        let configuration: UIButton.Configuration = action.isPrimary ? .primary(title: action.title,image: action.image) : .secondary(title: action.title,image: action.image)
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.autoSetDimension(.height, toSize: 48)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        button.tag = stackView.arrangedSubviews.count
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let actionIndex = sender.tag
        let action = actions[actionIndex]
        action.handler()
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension AlertViewController: ContentSizeProvider {
    func contentSize(for maxHeight: CGFloat) -> CGSize {
        let targetSize = CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
        var contentSize = view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .defaultLow
        )
        contentSize.height = min(contentSize.height, maxHeight)

        if view.safeAreaInsets.bottom != .zero {
            contentSize.height -= view.safeAreaInsets.bottom
        }
        
        return contentSize
    }
}
