//
//  RadioButton.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//


import UIKit

class RadioButton: UIView {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(imageView)
        imageView.tintColor = .systemRed
        imageView.autoPinEdgesToSuperviewEdges() // PureLayout for full constraints
        updateImage(isSelected: false)
    }

    func updateImage(isSelected: Bool) {
        let imageName = isSelected ? "circle.inset.filled" : "circle"
        imageView.image = UIImage(systemName: imageName)
    }
}
