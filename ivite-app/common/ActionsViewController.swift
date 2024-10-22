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
    let handler: (() -> Void)
}

class ActionsViewController: BaseViewController {

    private let stackView = UIStackView()
    private var actions: [ActionItem] = []

    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white.withAlphaComponent(0.9)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.addSubview(stackView)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .accent
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        view.addSubview(closeButton)
        
        setupStackView()
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        stackView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        if let closeButton = view.subviews.last as? UIButton {
            closeButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            closeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        }
    }

    func setActions(_ actions: [ActionItem]) {
        self.actions = actions
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for action in actions {
            let button = createButton(for: action)
            stackView.addArrangedSubview(button)
        }
    }

    private func createButton(for action: ActionItem) -> UIButton {
        let button = UIButton(configuration: .actionButton(title: action.title, image: action.image))
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
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

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
}

