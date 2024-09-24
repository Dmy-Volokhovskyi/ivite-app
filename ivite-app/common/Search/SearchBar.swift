//
//  SearchBar.swift
//  ivite-app
//
//  Created by GoApps Developer on 05/09/2024.
//

import UIKit

final class SearchBar: BaseView {
    private let searchIcon = UIImageView(image: .search)
    private let searchTextField = UITextField()
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 22
        backgroundColor = .dark10
        
        searchTextField.placeholder = "Search for events"
        
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        
        [
            searchIcon,
            searchTextField
        ].forEach({ addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        searchIcon.autoMatch(.width, to: .height, of: searchIcon)
        
        searchIcon.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 13,
                                                                   left: 13,
                                                                   bottom: 13,
                                                                   right: .zero),
                                                excludingEdge: .trailing)
        
        searchTextField.autoPinEdge(.leading, to: .trailing, of: searchIcon, withOffset: 8)
        
        searchTextField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12,
                                                                        left: .zero,
                                                                        bottom: 12,
                                                                        right: 13),
                                                     excludingEdge: .leading)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        return searchTextField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
        return searchTextField.resignFirstResponder()
    }
}
