//
//  ActionsViewController.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 21/10/2024.
//

import UIKit
import PureLayout

// Define an Action Model
struct ActionItem {
    let title: String
    let image: UIImage?
    let isPrimary: Bool
    let handler: (() -> Void)
}

class ActionsViewController: BaseViewController {
    
    let closeButton = UIButton(type: .system)
    private let stackView = UIStackView()
    private var actions: [ActionItem] = []
    
    override func setupView() {
        super.setupView()
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .secondary70
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        view.backgroundColor = .dark10
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.addSubview(stackView)
    
        view.addSubview(closeButton)
        
        setupStackView()
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        closeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        closeButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        stackView.autoPinEdge(.top, to: .bottom, of: closeButton)
        stackView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        stackView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        stackView.autoPinEdge(toSuperviewSafeArea: .bottom)
    }
    
    func setActions(_ actions: [ActionItem]) {
        self.actions = actions
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for action in actions {
            let button = createButton(for: action)
            stackView.addArrangedSubview(button)
        }
        
        view.invalidateIntrinsicContentSize()
    }
    
    private func createButton(for action: ActionItem) -> UIControl {
        let button = AlertActionControl(title: action.title, image: action.image)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.autoSetDimension(.height, toSize: 52)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        button.tag = stackView.arrangedSubviews.count
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let actionIndex = sender.tag
        let action = actions[actionIndex]
        dismissVC() {
            action.handler()
        }
    }
    
    @objc private func dismissVC(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
    
    private func setupStackView() {
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
    }
}

extension ActionsViewController: ContentSizeProvider {
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

final class AlertActionControl: BaseControll {
    let image = UIImageView()
    let title = UILabel()
    
    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        self.image.image = image
        self.title.text = title
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 8
        backgroundColor = .clear
        
        title.textColor = .secondary1
        title.font = .interFont(ofSize: 16, weight: .regular)
        
        image.tintColor = .secondary70
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(title)
        addSubview(image)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        image.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 14, left: 12, bottom: 14, right: .zero), excludingEdge: .trailing)
        
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        title.autoPinEdge(.leading, to: .trailing, of: image, withOffset: 12)
        title.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 14, left: 12, bottom: 14, right: .zero), excludingEdge: .leading)
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
