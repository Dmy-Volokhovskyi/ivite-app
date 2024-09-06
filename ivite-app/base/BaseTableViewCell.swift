//
//  BaseTableViewCell.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//

import UIKit
import Reusable

class BaseTableViewCell: UITableViewCell, ReusableView {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellDidLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cellDidLoad()
    }
    
    private func cellDidLoad() {
        setupCell()
        addCellSubviews()
        constrainCellSubviews()
    }
    
    func setupCell() {
        selectionStyle = .none
    }
    
    func addCellSubviews() {
    }
    
    func constrainCellSubviews() {
    }
}
