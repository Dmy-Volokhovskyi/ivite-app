//
//  SearchFilterView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 08/11/2024.
//

import UIKit

protocol SearchFilterViewDelegate: AnyObject {
    func searchFilterViewDidTapFilterButton()
    func searchFilterViewDidTapDeleteButton()
    func searchFieldTextFieldDidChange(_ text: String?)
}

final class SearchFilterView: BaseView {
    private let contentStack = UIStackView()
    private let searchTexField = IVTextField(placeholder: "Search for name or email", leadingImage: .search)
    private let filterButton = UIButton(configuration: .image(image: .filter))
    private let deleteButton = UIButton(configuration: .image(image: .trash))
    
    weak var delegate: SearchFilterViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        contentStack.spacing = 11
        
        searchTexField.delegate = self
        
        filterButton.addTarget(self, action: #selector(didTouchFilterButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTouchDeleteButton), for: .touchUpInside)
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
    
    public func configure(filter: FilterType, text: String?) {
        filterButton.configuration = .image(image: filter.image)
        searchTexField.text = text
    }
    
    @objc private func didTouchFilterButton(_ sender: UIButton) {
        delegate?.searchFilterViewDidTapFilterButton()
    }
    
    @objc private func didTouchDeleteButton(_ sender: UIButton) {
        delegate?.searchFilterViewDidTapDeleteButton()
    }
}

extension SearchFilterView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        delegate?.searchFieldTextFieldDidChange(textField.text)
    }
}
