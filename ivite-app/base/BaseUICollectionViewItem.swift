//
//  BaseUICollectionViewItem.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//

import UIKit
import Reusable

class BaseUICollectionViewItem: UICollectionViewCell, ReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellDidLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cellDidLoad()
    }
    
    private func cellDidLoad() {
        setupCell()
        addSubviews()
        constrainSubviews()
    }
    
    func setupCell() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func addSubviews() { }
    func constrainSubviews() { }
}

