//
//  AddCoHostView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 14/10/2024.
//

import UIKit

protocol AddCoHostViewDelegate: AnyObject {
    func didAddCoHost(coHost: CoHost)
}

final class AddCoHostView: BaseView {
    private let addCoHostHeader = IVHeaderLabel(text: "Add Co Host")
    private let coHostNameTextFiel = IVTextField(placeholder: "Name")
    private let coHostNameEntryView = EntryWithTitleView(title: "Co host name")
    private let coHostEmailTextFiel = IVTextField(placeholder: "Email", validationType: .email)
    private let coHostEmailEntryView = EntryWithTitleView(title: "Co host email")
    private let saveButton = UIButton(configuration: .primary(title: "Save", insets: NSDirectionalEdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)))
    
    weak var delegate: AddCoHostViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        coHostNameEntryView.setContentView(coHostNameTextFiel)
        coHostNameTextFiel.delegate = self
        coHostEmailEntryView.setContentView(coHostEmailTextFiel)
        coHostEmailTextFiel.delegate = self
        
        saveButton.addTarget(self, action: #selector(didTouchSaveButton), for: .touchUpInside)
        manageSaveEnabled()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            addCoHostHeader,
            coHostNameEntryView,
            coHostEmailEntryView,
            saveButton
        ].forEach({ addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        addCoHostHeader.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 32, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        coHostNameEntryView.autoPinEdge(.top, to: .bottom, of: addCoHostHeader, withOffset: 24)
        coHostNameEntryView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        coHostNameEntryView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        coHostEmailEntryView.autoPinEdge(.top, to: .bottom, of: coHostNameEntryView, withOffset: 12)
        coHostEmailEntryView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        coHostEmailEntryView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        saveButton.autoPinEdge(.top, to: .bottom, of: coHostEmailEntryView, withOffset: 24)
        saveButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 32, relation: .greaterThanOrEqual)
    }
    
    private func manageSaveEnabled() {
        if coHostNameTextFiel.isValid && coHostEmailTextFiel.isValid {
            saveButton.configuration = .primary(title: "Save")
            saveButton.isUserInteractionEnabled = true
        } else {
            saveButton.configuration = .disabledPrimary(title: "Save")
            saveButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func didTouchSaveButton(_ sender: UIButton) {
        guard let name = coHostNameTextFiel.text, let email = coHostEmailTextFiel.text else { return }
        let coHost = CoHost(name: name, email: email)
        
        delegate?.didAddCoHost(coHost: coHost)
    }
}

extension AddCoHostView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        manageSaveEnabled()
    }
}
