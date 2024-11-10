//
//  SearchFilterView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 08/11/2024.
//

import UIKit

final class SearchFilterView: BaseView {
    private let contentStack = UIStackView()
    private let searchTexField = IVTextField(placeholder: "Search for name or email", leadingImage: .search)
    private let filterButton = UIButton(configuration: .image(image: .filter))
    private let deleteButton = UIButton(configuration: .image(image: .orangeTrash))
    
    override func setupView() {
        super.setupView()
        
        contentStack.spacing = 11
    }
     
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(contentStack)
        
        [
            searchTexField,
            filterButton,
            deleteButton
        ].forEach({ contentStack.addArrangedSubview($0) })
    }
     
    override func constrainSubviews() {
        super.constrainSubviews()
        
        contentStack.autoPinEdgesToSuperviewEdges()
    }
}
