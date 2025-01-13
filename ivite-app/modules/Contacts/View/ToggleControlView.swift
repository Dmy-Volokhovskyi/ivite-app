//
//  ToggleControlView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 06/01/2025.
//

import UIKit

final class CustomSegmentedControl: BaseView {
    
    private let stackView = UIStackView()
    private let contactButton = UIButton(configuration: .transparent(title: "Contact"))
    private let groupButton = UIButton(configuration: .transparent(title: "Group"))
    private let selectorView = UIView()
    
    private var buttons: [UIButton] = []
    
    var selectedIndex: Int = 0 {
        didSet {
            updateSelectorPosition()
        }
    }
    private var selectorLeadingConstraint: NSLayoutConstraint?
    
    var onIndexChanged: ((Int) -> Void)?
    
    override func setupView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        selectorView.backgroundColor = .accent
        selectorView.layer.cornerRadius = 12
        selectorView.isUserInteractionEnabled = true
        
        configureButton(contactButton, isPrimary: true)
        configureButton(groupButton, isPrimary: false)
        buttons = [contactButton, groupButton]
        
        layer.cornerRadius = 16
        backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 1.0, alpha: 1.0)
    }
    
    override func addSubviews() {
        addSubview(selectorView)
        addSubview(stackView)
        stackView.addArrangedSubview(contactButton)
        stackView.addArrangedSubview(groupButton)
    }
    
    override func constrainSubviews() {
        stackView.autoPinEdgesToSuperviewEdges()
        
        selectorView.autoPinEdge(toSuperviewEdge: .top)
        selectorView.autoPinEdge(toSuperviewEdge: .bottom)
        selectorView.autoMatch(.width, to: .width, of: contactButton)
        selectorLeadingConstraint = selectorView.autoPinEdge(.leading, to: .leading, of: contactButton)
    }
    
    private func configureButton(_ button: UIButton, isPrimary: Bool) {
        let configuration = isPrimary
        ? UIButton.Configuration.primary(title: button.configuration?.title ?? "", image: button.configuration?.image)
        : UIButton.Configuration.transparent(title: button.configuration?.title ?? "", image: button.configuration?.image)
        button.configuration = configuration
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender), index != selectedIndex else { return }
        selectedIndex = index
        onIndexChanged?(index)
    }
    
    private func updateSelectorPosition() {
        selectorLeadingConstraint?.isActive = false
        selectorLeadingConstraint = selectorView.autoPinEdge(.leading, to: .leading, of: buttons[selectedIndex])
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
        updateButtonStyles()
    }
    
    private func updateButtonStyles() {
        for (index, button) in buttons.enumerated() {
            configureButton(button, isPrimary: index == selectedIndex)
        }
    }
}

