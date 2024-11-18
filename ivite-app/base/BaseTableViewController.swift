//
//  BaseTableViewController.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 17/11/2024.
//


import UIKit

class BaseTableViewController: BaseViewController {
    var tableView = UITableView()
    
    init(style: UITableView.Style = .plain) {
        super.init()
        tableView = UITableView(frame: .zero, style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupView() {
        super.setupView()
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(tableView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        tableView.autoPinEdgesToSuperviewEdges() // Assuming you use PureLayout
    }
}
