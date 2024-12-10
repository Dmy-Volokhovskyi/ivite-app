//
//  DynamicSearchBar.swift
//  ivite-app
//
//  Created by GoApps Developer on 05/09/2024.
//

import UIKit

protocol DynamicSearchBarDelegate: AnyObject {
   func textFieldDidChange(_ textField: IVTextField)
}

final class DynamicSearchBar: BaseView {
    private let searchButton = UIButton(configuration: .image(image: .search))
    private let cancelButton = UIButton(configuration: .image(image: .close))
    private let searchTextField = IVTextField(placeholder: "Search", leadingImage: .search)
    
    private var foldedSearchButtonLeadingConstraint: NSLayoutConstraint?
    private var foldedSearchButtonTrailingConstraint: NSLayoutConstraint?
    
    private var unFoldedSearchButtonTrailingConstraint: NSLayoutConstraint?
    
    weak var delegate: DynamicSearchBarDelegate?
    
    override func setupView() {
        super.setupView()
        
        searchTextField.isHidden = true
        cancelButton.isHidden = true
        
        searchButton.layer.cornerRadius = 22
        cancelButton.layer.cornerRadius = 22
        
        searchButton.addTarget(self, action: #selector(unfoldSearchBarDidTouch), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelSearchDidTouch), for: .touchUpInside)
        
        searchTextField.delegate = self
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            searchButton,
            cancelButton,
            searchTextField
        ].forEach(addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        searchTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        cancelButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        searchTextField.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)
        
        cancelButton.autoPinEdge(.leading, to: .trailing, of: searchTextField, withOffset: 8)
        cancelButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        
        searchButton.autoPinEdge(toSuperviewEdge: .top)
        searchButton.autoPinEdge(toSuperviewEdge: .bottom)
        
        foldedSearchButtonLeadingConstraint = searchButton.autoPinEdge(toSuperviewEdge: .leading)
        foldedSearchButtonLeadingConstraint?.isActive = false
        
        foldedSearchButtonTrailingConstraint = searchButton.autoPinEdge(toSuperviewEdge: .trailing)
        
        unFoldedSearchButtonTrailingConstraint = searchButton.autoPinEdge(.trailing, to: .trailing, of: searchTextField)
        unFoldedSearchButtonTrailingConstraint?.isActive = false
    }
    
    func fold(_ fold: Bool) {
        
    }
    #warning("Work On animation")
    @objc private func unfoldSearchBarDidTouch(_ sender: UIButton) {
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut, animations: {
            self.foldedSearchButtonLeadingConstraint?.isActive = true
            self.foldedSearchButtonTrailingConstraint?.isActive = false
            self.unFoldedSearchButtonTrailingConstraint?.isActive = true
            self.layoutIfNeeded()
        }, completion: { _ in
            self.searchTextField.isHidden = false
            self.searchTextField.becomeFirstResponder()
            self.cancelButton.isHidden = false
        })
    }
    
    @objc private func cancelSearchDidTouch(_ sender: UIButton) {
        searchButton.isHidden = false
        cancelButton.isHidden = true
        searchTextField.isHidden = true
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut, animations: {
            self.unFoldedSearchButtonTrailingConstraint?.isActive = false
            self.foldedSearchButtonTrailingConstraint?.isActive = true
            self.foldedSearchButtonLeadingConstraint?.isActive = false
            self.layoutIfNeeded()
        }, completion: { _ in
            self.searchTextField.resignFirstResponder()
            self.cancelButton.isHidden = true
        })
    }
}

extension DynamicSearchBar: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        delegate?.textFieldDidChange(textField)
    }
}
