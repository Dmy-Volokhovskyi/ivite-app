//
//  HostView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 12/10/2024.
//

import UIKit

protocol HostViewDelegate: AnyObject {
    func didTapAddCoHostButton()
    func didTouchMenu(for coHost: CoHost)
}

final class HostView: BaseView {
    private let model: EventDetailsViewModel
    private let hostedHeader = IVHeaderLabel(text: "Hosted")
    private let contentStackView = UIStackView()
    private let hostedByEntry = EntryWithTitleView(title: "Hosted by")
    private let hostNameTextField: IVTextField
    private let coHostedEntry = EntryWithTitleView(title: "Co-Hosted by")
    private let coHostStackView = UIStackView()
    private let addCoHostButton = UIButton(configuration: .secondary(title: "Add Co-Host"))
    
    weak var delegate: HostViewDelegate?
    
    init(model: EventDetailsViewModel) {
        self.model = model
        self.hostNameTextField = IVTextField(text: model.hostName, placeholder: "Host name")
        
        super.init(frame: .zero)
        
        model.coHosts.forEach({
            coHostStackView.addArrangedSubview(CoHostView(coHost: $0))
        })
        coHostedEntry.isHidden = model.coHosts.isEmpty
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        
        coHostStackView.axis = .vertical
        coHostStackView.spacing = 16
        
        hostedByEntry.setContentView(hostNameTextField)
        coHostedEntry.setContentView(coHostStackView)
        
        hostNameTextField.delegate = self
        
        addCoHostButton.addTarget(self, action: #selector(didtTouchAddCoHostButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            contentStackView,
            hostedHeader,
            addCoHostButton
        ].forEach(addSubview)
        
        [
            hostedByEntry,
            coHostedEntry
        ].forEach({ contentStackView.addArrangedSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        hostedHeader.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        contentStackView.autoPinEdge(.top, to: .bottom, of: hostedHeader, withOffset: 16)
        contentStackView.autoPinEdge(toSuperviewEdge: .leading)
        contentStackView.autoPinEdge(toSuperviewEdge: .trailing)
        
        addCoHostButton.autoPinEdge(.top, to: .bottom, of: contentStackView, withOffset: 16)
        addCoHostButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc private func didtTouchAddCoHostButton(_ sender: UIButton) {
        delegate?.didTapAddCoHostButton()
    }
    
    public func updateCoHosts(_ coHosts: [CoHost]) {
        coHostStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        coHosts.forEach({
            let view = CoHostView(coHost: $0)
            view.delegate = self
            coHostStackView.addArrangedSubview(view)
        })
        print(model.coHosts)
        
        coHostedEntry.isHidden = coHosts.isEmpty
    }
}

extension HostView: CoHostViewDelegate {
    func coHostView(_ view: CoHost) {
        delegate?.didTouchMenu(for: view)
    }
}

extension HostView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        model.hostName = textField.text
    }
}
