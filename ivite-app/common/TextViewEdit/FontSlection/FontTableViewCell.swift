//
//  FontTableViewCell.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import UIKit
import Reusable

class FontTableViewCell: BaseTableViewCell {
    
    let fontLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        constrainSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        constrainSubviews()
    }
    
    private func addSubviews() {
        contentView.addSubview(fontLabel)
    }
    
    private func constrainSubviews() {
        fontLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
    }
    
    func configure(with fontName: String, isSelected: Bool) {
        fontLabel.text = fontName
        fontLabel.font = UIFont(name: fontName, size: 16)
        if isSelected {
            imageView?.image = UIImage(resource: .chewronDown)
        }
    }
}
