//
//  EdditCoHostView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 21/10/2024.
//

import UIKit

protocol EdditCoHostViewDelegate: AnyObject {
    func didEdditCoHost(coHost: CoHost)
}

final class EdditCoHostView: BaseView{
    private let addCoHostHeader = IVHeaderLabel(text: "Eddit Co Host")
    private let coHostNameTextFiel = IVTextField(placeholder: "Name")
    private let coHostNameEntryView = EntryWithTitleView(title: "Co host name")
    private let coHostEmailTextFiel = IVTextField(placeholder: "Email", validationType: .email)
    private let coHostEmailEntryView = EntryWithTitleView(title: "Co host email")
    private let saveButton = UIButton(configuration: .primary(title: "Save", insets: NSDirectionalEdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)))
    
    private var coHost: CoHost
    weak var delegate: EdditCoHostViewDelegate?
    
    init(coHost: CoHost) {
        self.coHost = coHost
        super.init()
        
        coHostNameTextFiel.text = coHost.name
        coHostEmailTextFiel.text = coHost.email
        manageSaveEnabled()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        coHostNameEntryView.setContentView(coHostNameTextFiel)
        coHostEmailEntryView.setContentView(coHostEmailTextFiel)
        
        coHostNameTextFiel.delegate = self
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
        guard let name = coHostNameTextFiel.text, let email = coHostNameTextFiel.text else { return }
        coHost.name = name
        coHost.email = email
        delegate?.didEdditCoHost(coHost: coHost)
    }
}

extension EdditCoHostView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        manageSaveEnabled()
    }
}
