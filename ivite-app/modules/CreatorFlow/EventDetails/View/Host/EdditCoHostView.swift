//
//  EdditCoHostView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 21/10/2024.
//

import UIKit

protocol EdditCoHostViewControllerDelegate: AnyObject {
    func didEdditCoHost(coHost: CoHost)
}

final class EdditCoHostViewController: BaseViewController {
    private let addCoHostHeader = IVHeaderLabel(text: "Eddit Co Host")
    private let coHostNameTextFiel = IVTextField(placeholder: "Name")
    private let coHostNameEntryView = EntryWithTitleView(title: "Co host name")
    private let coHostEmailTextFiel = IVTextField(placeholder: "Email", validationType: .email)
    private let coHostEmailEntryView = EntryWithTitleView(title: "Co host email")
    private let saveButton = UIButton(configuration: .primary(title: "Save"))
    
    private var coHost: CoHost
    weak var delegate: EdditCoHostViewControllerDelegate?
    
    init(coHost: CoHost) {
        self.coHost = coHost
        super.init()
        
        coHostNameTextFiel.text = coHost.name
        coHostEmailTextFiel.text = coHost.email
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        
        coHostNameEntryView.setContentView(coHostNameTextFiel)
        coHostEmailEntryView.setContentView(coHostEmailTextFiel)
        
        saveButton.addTarget(self, action: #selector(didTouchSaveButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            addCoHostHeader,
            coHostNameEntryView,
            coHostEmailEntryView,
            saveButton
        ].forEach({ view.addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        addCoHostHeader.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 32, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        coHostNameEntryView.autoPinEdge(.top, to: .bottom, of: addCoHostHeader)
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
    
    @objc private func didTouchSaveButton(_ sender: UIButton) {
        guard let name = coHostNameTextFiel.text, let email = coHostNameTextFiel.text else { return }
        #warning("Work on Error handling")
        coHost.name = name
        coHost.email = email
        delegate?.didEdditCoHost(coHost: coHost)
        self.dismiss(animated: true)
    }
}
