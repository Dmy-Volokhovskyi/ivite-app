//
//  TileCollectionViewCell.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import UIKit

final class TileCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TileCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        titleLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 12)
        titleLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: TileModel) {
        imageView.image = model.image
        titleLabel.text = model.title
    }
}
