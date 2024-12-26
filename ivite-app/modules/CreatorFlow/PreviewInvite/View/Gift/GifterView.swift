//
//  GifterView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/12/2024.
//

import UIKit

final class GifterView: BaseView {
    private let giftImageView = UIImageView(image: .giftBoxWithABow20X20)
    private let gifterNameLabel = UILabel()
        
    override func setupView() {
        super.setupView()
        
        backgroundColor = .dark20
        layer.cornerRadius = 6
        
        gifterNameLabel.textColor = .dark30
        gifterNameLabel.font = .interFont(ofSize: 16, weight: .regular)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(giftImageView)
        addSubview(gifterNameLabel)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        giftImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), excludingEdge: .trailing)
        giftImageView.autoMatch(.width, to: .height, of: giftImageView)
        giftImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        giftImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        gifterNameLabel.autoPinEdge(.leading, to: .trailing, of: giftImageView, withOffset: 10)
        gifterNameLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), excludingEdge: .leading)
        gifterNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        gifterNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    public func configure(with gifterName: String?) {
        if let gifterName {
            gifterNameLabel.text = gifterName
            gifterNameLabel.textColor = .secondary1
            giftImageView.tintColor = .accent
        } else {
            gifterNameLabel.text = "None"
            giftImageView.tintColor = .dark30
            gifterNameLabel.textColor = .dark30
        }
    }
}
