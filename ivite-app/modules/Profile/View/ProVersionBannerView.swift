//
//  ProVersionBannerView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 06/01/2025.
//

import UIKit

final class ProVersionBannerView: BaseControll {
    private let gradientLayer = CAGradientLayer()
    private let mainStackView = UIStackView()
    private let secondaryStackView = UIStackView()
    private let diamondImageView = UIImageView(image: .diamond1)
    private let proLabel = UILabel()
    private let proDescriptionLabel = UILabel()
    private let arrowImageView = UIImageView(image: .arrowRight)
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 14
        clipsToBounds = true
        
        mainStackView.axis = .vertical
        
        secondaryStackView.alignment = .leading
        secondaryStackView.distribution = .fill
        secondaryStackView.spacing = 20
        
        setupGradientBackground()
        
        proLabel.text = "Pro version"
        proLabel.font = .interFont(ofSize: 20, weight: .semiBold)
        proLabel.textColor = .accent
        
        proDescriptionLabel.text = "Use the platform without restrictions"
        proDescriptionLabel.font = .interFont(ofSize: 14, weight: .regular)
        proDescriptionLabel.textColor = .accent
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        secondaryStackView.addArrangedSubview(proLabel)
        secondaryStackView.addArrangedSubview(arrowImageView)
        
        mainStackView.addArrangedSubview(secondaryStackView)
        mainStackView.addArrangedSubview(proDescriptionLabel)
        
        [
            diamondImageView,
            mainStackView
        ].forEach(addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        diamondImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        diamondImageView.autoAlignAxis(.horizontal, toSameAxisOf: mainStackView)
        diamondImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        mainStackView.autoPinEdge(.leading, to: .trailing, of: diamondImageView, withOffset: 16)
        mainStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 16), excludingEdge: .leading)
        
        mainStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        arrowImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupGradientBackground() {
        gradientLayer.colors = [
            UIColor(red: 0.99, green: 0.94, blue: 0.93, alpha: 1.0).cgColor, // Hex #FDF0EC (Start)
            UIColor(red: 0.99, green: 0.94, blue: 0.93, alpha: 0.0).cgColor  // Hex #FDF0EC (End with 0% opacity)
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.cornerRadius = 14
        layer.insertSublayer(gradientLayer, at: 0)
        print("Gradient Background added")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient frame to match the view's bounds
        gradientLayer.frame = bounds
    }
}
