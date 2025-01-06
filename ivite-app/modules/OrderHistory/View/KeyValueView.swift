//
//  KeyValueView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 06/01/2025.
//

import UIKit

final class KeyValueView: BaseView {
    private let stackView = UIStackView()
    private let keyLabel = UILabel()
    private let valueLabel = UILabel()
    
    override func setupView() {
        super.setupView()
        
        stackView.distribution = .fillEqually
        
        keyLabel.font = .interFont(ofSize: 16, weight: .regular)
        keyLabel.textColor = .dark30
        
        valueLabel.font = .interFont(ofSize: 16, weight: .regular)
        valueLabel.textColor = .secondary1
        valueLabel.textAlignment = .right
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(keyLabel)
        stackView.addArrangedSubview(valueLabel)
        
        keyLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        stackView.autoPinEdgesToSuperviewEdges()
    }

    func configure(key: String, value: String, valueColor: UIColor = .secondary1) {
        keyLabel.text = key
        valueLabel.text = value
        valueLabel.textColor = valueColor
    }
}
